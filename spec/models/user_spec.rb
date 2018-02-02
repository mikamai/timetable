# frozen_string_literal: true

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
      subject = create :user, :organized, org_admin: true
      expect(subject).to be_admin_in_organization subject.organizations.first
    end

    it 'returns false if the user is admin for the given organization' do
      subject = create :user, :organized, org_admin: false
      expect(subject).not_to be_admin_in_organization subject.organizations.first
    end

    it 'manages to work if just the organization id is provided' do
      subject = create :user, :organized, org_admin: true
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
end
