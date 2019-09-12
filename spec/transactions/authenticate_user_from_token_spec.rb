# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticateUserFromToken do
  let(:user) { create(:user) }
  let!(:tokens) { generate_tokens(user) }
  let(:organization) { create(:organization) }

  context 'Success' do
    let!(:organization_membership) {create(:organization_member, user: user, organization: organization)}

    it 'returns the user for a valid token' do
      transaction = described_class.new.call authorization_header: tokens[:valid_token], public_key: tokens[:public_key]
      expect(transaction.success).to eq user
    end
  end

  context 'Failure' do
    it 'fails if no token is given' do
      transaction = described_class.new.call authorization_header: nil
      expect(transaction.failure[:message][:credentials].count).to eq 1
    end

    it 'creates new user if not found' do
      expect{
        transaction = described_class.new.call authorization_header: tokens[:no_user_token], public_key: tokens[:public_key]
      }.to change(User, :count).by 1
    end
  end
end