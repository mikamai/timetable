# frozen_string_literal: true

require 'rails_helper'
require 'net/http'

RSpec.describe Api::TimeEntriesController, type: :controller do
  let(:organization) { create :organization }
  let(:user) { create :user, :organized, organization: organization }
  let!(:tokens) { generate_tokens(user) }

  before do
    allow_any_instance_of(ApplicationHelper).to receive(:set_public_key).and_return tokens[:public_key]
  end

  shared_examples 'request for self' do | action |
    context 'api request for himself' do
      let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
      let(:project) { create :project, organization: organization, users: [user] }
      let(:task) { create :task, projects: [project], organization: organization }
      let!(:time_entry) {create(:time_entry, user: user, organization: organization, executed_on: time_view_id, project: project )}
      let!(:time_entry2) {create(:time_entry, user: user, organization: organization, executed_on: time_view_id, project: project )}

      let(:other_organization) { create :organization }
      let(:other_project) {create :project, organization: other_organization, users: []}
      let(:other_time_entry) {create(:time_entry, user: user, organization: organization, executed_on: time_view_id, project: other_project )}

      let(:params) do
        {
          user_id: user.id,
          organization_id: organization.id,
          time_view_id: time_view_id,
          project_id: project.id,
          task_id: task.id,
          time_amount: "2:00",
          notes: 'Updated',
          id: time_entry.id,
        }
      end

      before do
        set_token tokens[:valid_token]
      end

      it 'return 200 with valid request' do
        call_action params
        expect(response.status.to_s).to match(/^20[0-2]{1}$/)

        verify_expectation_for action, user, project
      end

      it 'raises a 404 if parameters are missing' do
        call_action params.except(:task_id)

        expect(JSON.parse(response.body)).to eq({"error"=>"Task must exist"})
      end if action == "create"

      it 'raises an error if url params are incorrect' do
        incorrect_params = params.clone.merge({user_id: 'invalid-slug'})
        call_action incorrect_params
        expect(response.status).to eq 404
        expect(response.body.include?("User must exist")).to be true
      end

      it 'raises a 404 if user is not in organization' do
        incorrect_params = params.clone.merge({organization_id: other_organization.id})
        call_action incorrect_params

        expect(response.status).to eq 404
        expect(response.body.include?("Organization must exist")).to be true
      end

      it 'raises a 404 if project is not in organization' do
        incorrect_params = params.clone.merge({project_id: other_project.id})
        call_action incorrect_params

        expect(response.status).to eq 404
        expect(response.body.include?("Project must exist")).to be true
      end if action == "create" || action == "project_index"
    end
  end

  shared_examples 'request for someone else' do | action |
    context 'user sends api request for someone else' do
      let(:other_user) { create :user, :organized, organization: organization }
      let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
      let(:project) { create :project, organization: organization, users: [other_user] }
      let(:task) { create :task, projects: [project], organization: organization }
      let(:time_entry) {create(:time_entry, user: other_user, organization: organization, executed_on: time_view_id, project: project )}

      let(:other_organization) { create :organization }
      let(:other_project) {create :project, organization: other_organization, users: []}
      let(:other_task) { create :task, projects: [other_project], organization: other_organization }

      let(:params) do
        {
          user_id: other_user.id,
          organization_id: organization.id,
          time_view_id: time_view_id,
          project_id: project.id,
          task_id: task.id,
          time_amount: "2:00",
          notes: 'Updated',
          id: time_entry.id,
        }
      end

      before do
        set_token tokens[:valid_token]
      end

      it 'raises a 404 for a normal user' do
        set_organization_role user, organization, 'user'
        call_action params

        expect(response.status).to eq 403
      end

      it 'return 200 with valid request for an organisation admin' do
        set_organization_role user, organization, 'admin'
        call_action params

        expect(response.status.to_s).to match(/^20[0-2]{1}$/)
        verify_expectation_for action, other_user, project
      end

      it 'returns 403 for an application admin (for any user: not in organization)' do
        user.update_attributes admin: true
        call_action params
        expect(response.status).to eq 403
      end

      context 'for an organization super_user' do
        before do
          set_organization_role user, organization, 'super_user'
        end

        it 'return 200 with valid request' do
          call_action params

          expect(response.status.to_s).to match(/^20[0-2]{1}$/)
          verify_expectation_for action, other_user, project
        end

        it 'raises a 404 if parameters are missing' do
          call_action params.except(:task_id)
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)).to eq({"error"=>"Task must exist"})
        end if action == 'create'

        it 'raises a 404 if parameters are not authorized' do
          call_action params.clone.merge(task_id: other_task.id)
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)).to eq({"error"=>"Task must exist"})
        end if action == 'create' || action == 'update'

        it 'raises a 404 if user is not in organization' do
          incorrect_params = params.clone.merge({organization_id: other_organization.id})
          call_action incorrect_params

          expect(response.status).to eq 404
          expect(response.body.include?("Organization must exist")).to be true
        end

        it 'raises a 404 if project is not in organization' do
          incorrect_params = params.clone.merge({project_id: other_project.id})
          call_action incorrect_params

          expect(response.status).to eq 404
          expect(response.body.include?("Project must exist")).to be true
        end if action == 'create' || action == 'project_index'
      end
    end
  end

  ### action controller ###
  context 'GET index' do
    def call_action action_params
      get :index, params: action_params
    end

    include_examples 'request for self', 'index'
    include_examples 'request for someone else', 'index'
  end

  context 'GET index_project' do
    def call_action action_params
      get :index_project, params: action_params
    end

    include_examples 'request for self', 'index_project'
    include_examples 'request for someone else', 'index_project'
  end

  context 'POST create' do
    def call_action action_params
      post :create, params: action_params
    end

    include_examples 'request for self', 'create'
    include_examples 'request for someone else', 'create'
  end

  context 'PUT update' do
    def call_action action_params
      put :update, params: action_params
    end

    include_examples 'request for self', 'update'
    include_examples 'request for someone else', 'update'
  end

  context 'DELETE destroy' do
    def call_action action_params
      delete :destroy, params: action_params.slice(:user_id, :organization_id, :id)
    end

    include_examples 'request for self', 'destroy'
    include_examples 'request for someone else', 'destroy'
  end
end
