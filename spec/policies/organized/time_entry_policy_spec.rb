# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::TimeEntryPolicy do
  let(:user) { create :user }
  let(:organization_member) { create :organization_member, user: user }
  subject { described_class }

  permissions :create? do
    let(:resource) { create :time_entry, organization: organization_member.organization }

    it 'denies access if user is not an admin nor a super_user' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization super_user' do
      organization_member.update_column :role, 'admin'
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :role, 'admin'
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is the entry author' do
      resource.update_attribute :user, user
      expect(subject).to permit(organization_member, resource)
    end
  end

  permissions :update?, :destroy? do
    let(:resource) { create :time_entry, organization: organization_member.organization }

    it 'denies access if user is not an admin nor a super_user' do
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'denies access to an admin if resource is not in the same organization' do
      resource = create :time_entry
      organization_member.update_column :role, 'admin'
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'denies access to a super_user if resource is not in the same organization' do
      resource = create :time_entry
      organization_member.update_column :role, 'super_user'
      expect(subject).not_to permit(organization_member, resource)
    end

    it 'grants access if user is an organization super_user' do
      organization_member.update_column :role, 'super_user'
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :role, 'admin'
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is the entry author' do
      resource.update_attribute :user, user
      expect(subject).to permit(organization_member, resource)
    end
  end
end
