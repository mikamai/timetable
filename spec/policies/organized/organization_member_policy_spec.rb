# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::OrganizationMemberPolicy do
  let(:user) { create :user }
  let(:organization) { create :organization }
  let(:organization_member) { create :organization_member, organization: organization, user: user }
  subject { described_class }

  permissions :index? do
    let(:resource) { OrganizationMember }

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :create? do
    let(:resource) { create :organization_member, organization: organization }

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :show?, :toggle_admin? do
    let(:resource) { create :organization_member, organization: organization }

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'denies access if organization_member belongs to different organization' do
      resource.update_attribute :organization, create(:organization)
      organization_member.update_column :admin, true
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :destroy? do
    let(:resource) { create :organization_member, organization: organization }

    it 'denies access if resource is not destroyable' do
      expect(resource).to receive(:destroyable?).and_return false
      organization_member.update_column :admin, true
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'denies access if organization_member belongs to different organization' do
      resource.update_attribute :organization, create(:organization)
      organization_member.update_column :admin, true
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end
  end
end
