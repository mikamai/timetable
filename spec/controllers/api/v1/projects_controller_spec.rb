# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:organization) { create :organization }
  let(:user) { create :user, :organized, organizations: [organization] }
  let(:tokens) { generate_tokens(user) }
  let!(:project) { create :project, organization: organization, users: [user] }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  context 'GET projects' do
    before do
      set_token tokens[:valid_token]
    end

    it 'returns projects for user in organization' do
      get :index, params: { organization_id: organization.id, user_id: 'me' }
      expect(response.body).to include("\"total_count\":1,")
      expect(response.body).to include("\"data\":[{\"id\":\"#{project.id}\"")
    end

    it 'throws a 404 if org does not exist' do
      get :index, params: { organization_id: "Not existing", user_id: 'me' }
      expect(response.status).to eq 404
    end
  end
end
