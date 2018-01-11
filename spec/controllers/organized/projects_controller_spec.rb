# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::ProjectsController do
  let(:organization) { create :organization }

  shared_examples 'authentication' do
    context 'when user is not logged in' do
      before { call_action }

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user has no access to the current organization' do
      let(:user) { create :user, admin: true }

      it 'raises a 404' do
        sign_in user
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      it 'raises a 404' do
        sign_in user
        expect { call_action }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe 'GET index' do
    def call_action
      get :index, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :index }

      it 'assigns the projects' do
        expect(assigns[:projects]).to be_a ActiveRecord::Relation
        expect(assigns[:projects]).to respond_to :total_pages
      end

      it 'does not include projects of other organizations' do
        create :project
        project = create :project, organization: organization
        expect(assigns[:projects].to_a).to eq [project]
      end
    end
  end

  describe 'GET new' do
    def call_action
      get :new, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a newly built project' do
        expect(assigns[:project]).to be_a Project
        expect(assigns[:project]).to be_new_record
      end
    end
  end

  describe 'POST create' do
    let(:project_client) { create :client, organization: organization }
    let(:project_params) { { client_id: project_client.id, name: 'asd' } }

    def call_action
      post :create, params: { organization_id: organization.id, project: project_params }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      context 'and project data is valid' do
        it { is_expected.to respond_with :redirect }

        it 'creates a new project' do
          expect(assigns[:project]).to be_a Project
          expect(assigns[:project]).to be_persisted
          expect(organization.projects.count).to eq 1
        end
      end

      context 'and project data is invalid' do
        let(:project_params) { { name: '' } }

        it { is_expected.to render_template 'new' }
      end
    end
  end

  describe 'GET show' do
    let(:project) { create :project, organization: organization }

    def call_action
      get :show, format: 'json', params: { organization_id: organization.id, id: project.id }
    end

    context 'when user is not logged in' do
      before { call_action }

      it { is_expected.to respond_with :unauthorized }
    end

    context 'when user has no access to the current project' do
      it 'forbids access' do
        user = create :user, :organized, organization: organization
        sign_in user
        expect { call_action }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context 'when project user accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        project.members.create user: user
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }

      it 'assigns the project' do
        expect(assigns[:project]).to eq project
      end
    end
  end

  describe 'PUT update' do
    let(:project) { create :project, organization: organization }
    let(:project_params) { { name: 'asd' } }

    def call_action
      put :update, params: { organization_id: organization.id, id: project.id, project: project_params }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      context 'and project data is valid' do
        it { is_expected.to redirect_to organization_projects_path(organization) }

        it 'updates the project' do
          expect { project.reload }.to change(project, :name).to 'asd'
        end
      end

      context 'and project data is invalid' do
        let(:project_params) { { name: '' } }

        it { is_expected.to render_template 'edit' }
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }
      let(:project) { create :project }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
