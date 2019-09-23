# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::OrganizationsController, type: :controller do
  let(:user) { create :user, :organized }
  let(:tokens) { generate_tokens(user) }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  context 'GET projects' do
    before do
      set_token tokens[:valid_token]
    end

    it 'returns projects for user in organization' do
      get :index
      expect(response.body).to include("\"total_count\":1,")
      expect(response.body).to include("\"data\":[{\"id\":\"#{user.organizations.first.id}\"")
    end
  end
end
