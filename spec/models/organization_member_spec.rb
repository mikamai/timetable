# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMember, type: :model do
  describe 'validations' do
    it 'require an organization' do
      expect(subject).to have(1).error_on :organization
      subject.organization = build :organization
      expect(subject).to have(0).errors_on :organization
    end

    it 'require a user' do
      expect(subject).to have(1).error_on :user
      subject.user = build :user
      expect(subject).to have(0).errors_on :user
    end

    it 'require a unique user against the belonging organization' do
      existing = create :user, :organized
      subject.organization = existing.organizations.first
      subject.user = existing
      expect(subject).to have(1).error_on :user
      subject.organization = build :organization
      expect(subject).to have(0).errors_on :user
    end

    it 'pass when all constraints are met' do
      subject.organization = build :organization
      subject.user = build :user
      expect(subject).to be_valid
    end
  end

  it 'cannot be destroyed if the user is referenced in any project' do
    project = create :project
    user = create :user, :organized, organization: project.organization
    project_membership = create :project_member, user: user, project: project
    subject = user.organization_memberships.first

    expect(subject.destroy).to be_falsey
    project_membership.destroy
    expect(subject.destroy).to be_truthy
  end

  describe '#user_email' do
    it 'returns the previously set user_email' do
      subject.instance_variable_set '@user_email', 'asd'
      expect(subject.user_email).to eq 'asd'
    end

    it 'returns nil if user is not set' do
      expect(subject.user_email).to be_nil
    end

    it 'returns the user email' do
      subject.user = build :user, email: 'a@b.it'
      expect(subject.user_email).to eq 'a@b.it'
    end
  end

  describe '#user_email=' do
    it 'sets the email so that it can be retrieved later' do
      subject.user_email = 'asd'
      expect(subject.instance_variable_get('@user_email')).to eq 'asd'
    end

    it 'finds and sets the user via email' do
      u = create :user, email: 'a@b.it'
      expect { subject.user_email = 'a@b.it' }.to change(subject, :user).to u
    end

    it 'invites and sets the user via email if it does not exist' do
      subject.user_email = 'a@b.it'
      expect(subject.user).to be_a User
      expect(subject.user.invitation_token).to be_present
    end
  end
end
