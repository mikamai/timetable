# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    it 'require a name' do
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).errors_on :name
    end

    it 'require a unique name' do
      existing = create :organization
      subject.name = existing.name
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).error_on :name
    end

    it 'pass when all constraints are met' do
      subject.name = 'asd'
      expect(subject).to be_valid
    end
  end
end
