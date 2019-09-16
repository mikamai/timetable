# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::TasksController, type: :controller do
  let!(:organization) { create :organization }
  let!(:other) { create :organization }
  let!(:user) { create :user, :organized, organizations: [organization, other] }
  let!(:tokens) { generate_tokens(user) }
  let!(:project) { create :project, :with_tasks, organization: organization, users: [user] }
  let!(:project2) { create :project, :with_tasks, organization: other, users: [user] }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  context 'GET tasks' do
    def call_action params
      get :index, params: { organization_id: params }
    end

    before do
      set_token tokens[:valid_token]
    end

    it 'returns all tasks in scope' do
      get :index
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).length).to eq 4
    end

    it 'filters tasks by organization_id' do
      get :index, params: { organization_id: other.id }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).length).to eq 2
    end

    it 'filters tasks by project_id' do
      get :index, params: { id: project2.id }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).length).to eq 2
    end
  end
end
