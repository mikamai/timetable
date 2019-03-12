# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_roles_on_organization_id_and_slug  (organization_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#


require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    it 'require an organization' do
      expect(subject).to have(1).error_on :organization
      subject.organization = build :organization
      expect(subject).to have(0).errors_on :organization
    end

    it 'require a name' do
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).errors_on :name
    end

    it 'requires a unique name against the belonging organization' do
      existing = create :role
      subject.organization = existing.organization
      subject.name = existing.name
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).errors_on :name
    end

    it 'pass when all constraints are met' do
      subject.organization = create :organization
      subject.name = 'asd'
      expect(subject).to be_valid
    end
  end

  it 'cannot be destroyed if the role is referenced by any user' do
    subject = create :role
    user = create :user, :organized, organization: subject.organization
    user.roles << subject

    expect(subject.destroy).to be_falsey
    subject.users.clear
    expect(subject.destroy).to be_truthy
  end
end
