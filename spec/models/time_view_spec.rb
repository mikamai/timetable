# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeView do
  describe '::today' do
    let(:org) { create :organization }
    let(:user) { create :user, :organized, organization: org }

    it 'returns a TimeView for the current date' do
      instance = described_class.today org, user
      expect(instance).to be_a described_class
      expect(instance.date).to eq Date.today
    end
  end
end
