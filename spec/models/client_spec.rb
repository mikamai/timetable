# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    it 'require a name' do
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).errors_on :name
    end

    it 'require a unique name against the belonging organization' do
      c = create :client, name: 'asd'
      subject.organization = c.organization
      subject.name = 'asd'
      expect(subject).to have(1).error_on :name
      subject.organization = build :organization
      expect(subject).to have(0).error_on :name
    end

    it 'require an organization' do
      expect(subject).to have(1).error_on :organization
      subject.organization = build :organization
      expect(subject).to have(0).error_on :organization
    end

    it 'pass when all constraints are met' do
      subject.name = 'asd'
      subject.organization = build :organization
      expect(subject).to be_valid
    end
  end

  it 'cannot be destroyed if it is referenced in any project' do
    p = create :project
    subject = p.client
    expect(subject.destroy).to be_falsey
    p.destroy
    expect(subject.destroy).to be_truthy
  end
end
