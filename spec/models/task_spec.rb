# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#


require 'rails_helper'

RSpec.describe Task, type: :model do
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
      existing = create :task
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

  describe 'slug' do
    it 'is regenerated when name changes' do
      subject = create :task
      subject.name = 'asd'
      expect { subject.save! }.to change(subject, :slug).to 'asd'
    end
  end
end
