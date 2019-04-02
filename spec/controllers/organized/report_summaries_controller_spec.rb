# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::ReportSummariesController do
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
  end

  describe 'GET index' do
    def call_action
      get :index, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }
      before { sign_in user }

      it 'redirects to the client summary for the current week' do
        Timecop.freeze Date.new(2010, 1, 1) do
          call_action
          expect(response).to redirect_to clients_organization_report_summary_path(id: '2009-53')
        end
      end
    end
  end

  describe 'GET clients' do
    let(:week_id) { Date.today.strftime TimeEntry::WEEK_ID_FORMAT }

    def call_action
      get :clients, params: { organization_id: organization.id, id: week_id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before { sign_in user }

      context 'and there are rows made by current user' do
        before do
          tw = create :time_entry, organization: organization, user: user, amount: 1
          other_project = create :project, organization: organization, client: tw.project.client
          create :time_entry, organization: organization, user: user, project: other_project, amount: 2
          create :time_entry, organization: organization, user: user, amount: 4
        end

        it 'they are returned grouped by client' do
          call_action
          expect(assigns[:rows].map { |r| r.resource.class }).to eq [Client, Client]
          expect(assigns[:rows].map(&:amount)).to match_array [3, 4]
        end
      end

      context 'and there are rows made by other users' do
        before { create :time_entry, organization: organization }

        it 'they are not returned' do
          call_action
          expect(assigns[:rows]).to be_empty
        end
      end
    end

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before { sign_in user }

      it 'other user entries are returned' do
        create :time_entry, organization: organization
        call_action
        expect(assigns[:rows]).not_to be_empty
      end
    end
  end

  describe 'GET projects' do
    let(:week_id) { Date.today.strftime TimeEntry::WEEK_ID_FORMAT }

    def call_action
      get :projects, params: { organization_id: organization.id, id: week_id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before { sign_in user }

      context 'and there are rows made by current user' do
        before do
          tw = create :time_entry, organization: organization, user: user, amount: 1
          create :time_entry, organization: organization, user: user, project: tw.project, amount: 2
          other_project = create :project, organization: organization, client: tw.project.client
          create :time_entry, organization: organization, user: user, amount: 4, project: other_project
        end

        it 'they are returned grouped by client' do
          call_action
          expect(assigns[:rows].map { |r| r.resource.class }).to eq [Project, Project]
          expect(assigns[:rows].map(&:amount)).to match_array [3, 4]
        end
      end

      context 'and there are rows made by other users' do
        before { create :time_entry, organization: organization }

        it 'they are not returned' do
          call_action
          expect(assigns[:rows]).to be_empty
        end
      end
    end

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before { sign_in user }

      it 'other user entries are returned' do
        create :time_entry, organization: organization
        call_action
        expect(assigns[:rows]).not_to be_empty
      end
    end
  end

  describe 'GET tasks' do
    let(:week_id) { Date.today.strftime TimeEntry::WEEK_ID_FORMAT }

    def call_action
      get :tasks, params: { organization_id: organization.id, id: week_id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before { sign_in user }

      context 'and there are rows made by current user' do
        before do
          tw = create :time_entry, organization: organization, user: user, amount: 1
          create :time_entry, organization: organization, user: user, project: tw.project, task: tw.task, amount: 2
          other_task = create :task, organization: organization, projects: [tw.project]
          create :time_entry, organization: organization, user: user, amount: 4, project: tw.project, task: other_task
        end

        it 'they are returned grouped by client' do
          call_action
          expect(assigns[:rows].map { |r| r.resource.class }).to eq [Task, Task]
          expect(assigns[:rows].map(&:amount)).to match_array [3, 4]
        end
      end

      context 'and there are rows made by other users' do
        before { create :time_entry, organization: organization }

        it 'they are not returned' do
          call_action
          expect(assigns[:rows]).to be_empty
        end
      end
    end

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before { sign_in user }

      it 'other user entries are returned' do
        create :time_entry, organization: organization
        call_action
        expect(assigns[:rows]).not_to be_empty
      end
    end
  end

  describe 'GET team' do
    let(:week_id) { Date.today.strftime TimeEntry::WEEK_ID_FORMAT }

    def call_action
      get :team, params: { organization_id: organization.id, id: week_id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before { sign_in user }

      context 'and there are rows made by current user' do
        before do
          create :time_entry, organization: organization, user: user, amount: 1
          create :time_entry, organization: organization, user: user, amount: 2
        end

        it 'they are returned grouped by user' do
          call_action
          expect(assigns[:rows].map { |r| r.resource.class }).to eq [User]
          expect(assigns[:rows].map(&:amount)).to match_array [3]
        end
      end

      context 'and there are rows made by other users' do
        before { create :time_entry, organization: organization }

        it 'they are not returned' do
          call_action
          expect(assigns[:rows]).to be_empty
        end
      end
    end

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before { sign_in user }

      it 'other user entries are returned' do
        create :time_entry, organization: organization
        call_action
        expect(assigns[:rows]).not_to be_empty
      end
    end
  end
end
