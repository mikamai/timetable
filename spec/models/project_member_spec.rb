# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectMember, type: :model do
  describe 'validations' do
    it 'require a project' do
      expect(subject).to have(1).error_on :project
      subject.project = build :project
      expect(subject).to have(0).errors_on :project
    end

    it 'require a user' do
      expect(subject).to have(1).error_on :user
      subject.user = build :user
      expect(subject).to have(0).errors_on :user
    end
  end
end
