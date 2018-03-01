# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::ProjectPolicy do
  let(:user) { create :user }
  let(:organization_member) { create :organization_member, user: user }
  subject { described_class }

  permissions :index? do
    let(:resource) { Project }

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :create? do
    let(:resource) { create :project, organization: organization_member.organization }

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :update? do
    let(:resource) { create :project, organization: organization_member.organization }

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'denies access if client is in different organization' do
      resource.update_attribute :organization, create(:organization)
      organization_member.update_column :admin, true
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :show? do
    let(:resource) { create :project, organization: organization_member.organization }

    it 'denies access if client is in different organization' do
      resource.update_attribute :organization, create(:organization)
      organization_member.update_column :admin, true
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is in project' do
      user.project_memberships.create! project: resource
      expect(subject).to permit(organization_member, resource)
    end

    it 'denies access if user is not in project' do
      expect(subject).not_to permit(organization_member, resource)
    end
  end
end
