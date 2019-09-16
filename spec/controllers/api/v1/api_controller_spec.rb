# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::ApiController, type: :controller do
  let(:user) { create :user }
  let!(:tokens) { generate_tokens(user) }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  context 'GET me' do
    def call_action
      get :me
    end

    it 'raises a 401 for missing token' do
      call_action
      expect(response.status).to eq 401
      expect(response.body).to eq("{\"error\":{\"credentials\":[\"are missing\"]}}")
    end

    it 'raises a 401 for invalid token' do
      set_token tokens[:invalid_token]
      call_action
      expect(response.status).to eq 401
      expect(response.body).to eq("{\"error\":{\"decoding\":[\"JSON::JWS::VerificationFailed\"]}}")
    end

    it 'raises a 401 for an expired token' do
      set_token tokens[:expired_token]
      call_action
      expect(response.status).to eq 401
      expect(response.body).to eq("{\"error\":{\"expiration\":[\"is expired\"]}}")
    end

    it 'creates a missing user if valid token' do
      set_token tokens[:no_user_token]
      expect{
        call_action
        expect(response.status).to eq 200
      }.to change(User, :count).by 1
    end

    it 'returns the id if valid token' do
      set_token tokens[:valid_token]
      call_action
      expect(response.status).to eq 200
      expect(response.body).to include("{\"id\":\"#{user.id}\"")
    end
  end
end
