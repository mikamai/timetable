# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::ProjectsController, type: :controller do
  let!(:organization) { create :organization }
  let!(:other) { create :organization }
  let!(:user) { create :user, :organized, organizations: [organization, other] }
  let!(:tokens) { generate_tokens(user) }
  let!(:project) { create :project, organization: organization, users: [user] }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  context 'GET projects' do
    def call_action params
      get :index, params: { organization_id: params }
    end
    
    before do
      set_token tokens[:valid_token]
    end

    it 'returns all projects in scope' do
      get :index
      expect(response.status).to eq 200
      expect(response.body).to eq("[{\"id\":\"#{project.id}\",\"organization_id\":\"#{organization.id}\",\"name\":\"#{project.name}\",\"tasks\":[]}]")
    end

    it 'sort projects by organization' do
        get :index, params: { organization_id: other.id }
        expect(response.status).to eq 200
        expect(response.body).to eq("[]")
      end
  end
end