# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::TimeViewPolicy do
  let(:user) { create :user }
  let(:organization) { create :organization }
  let(:organization_member) { create :organization_member, user: user, organization: organization }
  subject { described_class }

  permissions :show? do
    let(:resource) { TimeView.today organization, user }

    it 'grants access if record is an instance and user matches' do
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is global admin' do
      user.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end

    it 'denies access if TimeView is in different organization' do
      organization_member.update_column :admin, true
      expect(subject).not_to permit(organization_member, TimeView.today(create(:organization), user))
    end

    it 'denies access if user does not match TimeView user' do
      expect(subject).not_to permit(organization_member, TimeView.today(organization, create(:user)))
    end
  end

  permissions :create? do
    let(:resource) { TimeView.today organization, user }

    it 'grants access if user is a global admin' do
      user.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is an organization admin' do
      organization_member.update_column :admin, true
      expect(subject).to permit(organization_member, resource)
    end

    it 'grants access if user is the entry author' do
      resource.user =user
      expect(subject).to permit(organization_member, resource)
    end
  end
end
