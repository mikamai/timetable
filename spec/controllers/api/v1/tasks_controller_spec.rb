# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:organization) { create :organization }
  let!(:user) { create :user, :organized, organizations: [organization] }
  let(:membership) { user.membership_in organization }
  let(:other) { create :user, :organized, organizations: [organization] }
  let!(:project) { create :project, :with_tasks, organization: organization, users: [other, user] }
  let!(:tokens) { generate_tokens(user) }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  context 'GET tasks' do
    def call_action user_id
      set_token tokens[:valid_token]
      get :index, params: { organization_id: organization.id, project_id: project.id, user_id: user_id }
    end

    it 'returns paginated tasks filtered by organization and projects' do
      call_action 'me'
      membership.update_attributes role: 'user'
      expect(response.body).to include("\"total_count\":2,")
      expect(response.body).to include("\"id\":\"#{project.tasks.first.id}\",")
      expect(response.body).to include("\"id\":\"#{project.tasks.second.id}\",")
    end

    it 'returns tasks for user if api_user is admin' do
      membership.update_attributes role: 'admin'
      call_action user.id
      expect(response.body).to include("\"total_count\":2,")
    end

    it 'returns unauthorized if outside scope' do
      membership.update_attributes role: 'user'
      call_action other.id
      expect(response.body).to include("{\"error\":\"Forbidden\"}")
    end
  end
end
