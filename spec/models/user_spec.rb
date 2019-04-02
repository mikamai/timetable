# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  openid_uid             :uuid
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :uuid
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_openid_uid            (openid_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (invited_by_id => users.id)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'require a first name' do
      expect(subject).to have(1).error_on :first_name
      subject.first_name = 'asd'
      expect(subject).to have(0).errors_on :first_name
    end

    it 'require a last name' do
      expect(subject).to have(1).error_on :last_name
      subject.last_name = 'asd'
      expect(subject).to have(0).errors_on :last_name
    end

    it 'pass when all constraints are met' do
      subject.first_name = 'asd'
      subject.last_name = 'asd'
      subject.email = 'asd@bar.it'
      subject.password = 'asd123$$$'
      expect(subject).to be_valid
    end
  end

  describe '#membership_in' do
    it 'returns a membership if the user belongs to the given organization' do
      subject = create :user, :organized
      membership = subject.membership_in subject.organizations.first
      expect(membership).to be_a OrganizationMember
      expect(membership.organization).to eq subject.organizations.first
    end

    it 'returns nil if the user does not belong to the given organization' do
      subject = create :user
      expect(subject.membership_in(create(:organization))).to be_nil
    end

    it 'returns a membership if the user belongs to the given project' do
      subject = create :user, :organized
      pm = create :project_member, user: subject,
                  project: create(:project, organization: subject.organizations.first)
      membership = subject.membership_in pm.project
      expect(membership).to be_a ProjectMember
      expect(membership.project).to eq subject.projects.first
    end

    it 'returns nil if the user does not belong to the given project' do
      subject = create :user, :organized
      project = create :project, organization: subject.organizations.first
      expect(subject.membership_in(project)).to be_nil
    end

    it 'returns a NotImplementedError if an unexpected object is given' do
      expect { subject.membership_in 'asd' }.to raise_error NotImplementedError
    end
  end

  describe '#admin_in_organization?' do
    it 'returns true if the user is admin for the given organization' do
      subject = create :user, :organized, org_role: 'admin'
      expect(subject).to be_admin_in_organization subject.organizations.first
    end

    it 'returns false if the user is admin for the given organization' do
      subject = create :user, :organized, org_role: 'user'
      expect(subject).not_to be_admin_in_organization subject.organizations.first
    end

    it 'manages to work if just the organization id is provided' do
      subject = create :user, :organized, org_role: 'admin'
      expect(subject).to be_admin_in_organization subject.organizations.first.id
    end

    it 'returns false if user does not belong to the given organization' do
      subject = create :user
      expect(subject).not_to be_admin_in_organization create(:organization)
    end
  end

  describe '::without_enough_entries_this_week' do
    subject { described_class }

    it 'returns the list of users assigned to a project who have tracked less than 40 hours' do
      pm = create :project_member
      create :time_entry, project: pm.project, organization: pm.project.organization, user: pm.user
      expect(subject.without_enough_entries_this_week).to eq [pm.user]
    end

    it 'returns the list of users assigned to a project who did not track hours' do
      pm = create :project_member
      expect(subject.without_enough_entries_this_week).to eq [pm.user]
    end

    it 'ignores users not assigned to a project' do
      pm = create :project_member
      create :time_entry, project: pm.project, organization: pm.project.organization, user: pm.user
      pm.destroy
      expect(subject.without_enough_entries_this_week).to be_empty
    end

    it 'ignores users with more than 40 hours this week' do
      pm = create :project_member
      create :time_entry, project: pm.project, organization: pm.project.organization, user: pm.user,
             executed_on: Date.today.beginning_of_week, amount: 1800
      create :time_entry, project: pm.project, organization: pm.project.organization, user: pm.user,
             executed_on: Date.today.end_of_week, amount: 601
      expect(subject.without_enough_entries_this_week).to be_empty
    end

    it 'ignores entries made outside of this week' do
      pm = create :project_member
      create :time_entry, project: pm.project, organization: pm.project.organization, user: pm.user,
             executed_on: Date.today.beginning_of_week - 1.day, amount: 2401
      create :time_entry, project: pm.project, organization: pm.project.organization, user: pm.user,
             executed_on: Date.today.end_of_week + 1.day, amount: 2401
      expect(subject.without_enough_entries_this_week).to eq [pm.user]
    end

  end

  describe 'omniauth' do
    subject { create :user }
    let(:info) { double email: subject.email, first_name: 'openid', last_name: 'openid' }
    let(:auth) { double uid: SecureRandom.uuid, info: info }

    it 'updates the user if logged in via OpenID' do
      user = User.from_omniauth(auth)
      subject.reload
      expect(subject.email).to eq user.email
      expect(subject.first_name).to eq 'openid'
      expect(subject.last_name).to eq 'openid'
      expect(subject.openid_uid).to eq auth.uid
    end

  end
end
