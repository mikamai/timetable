# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::TimeEntriesController do
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

  describe 'GET new' do
    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }

    def call_action
      get :new, params: { organization_id: organization.id, time_view_id: time_view_id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a newly built time_entry' do
        expect(assigns[:time_entry]).to be_a TimeEntry
        expect(assigns[:time_entry]).to be_new_record
      end
    end
  end

  describe 'POST create' do
    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
    let(:project) { create :project, organization: organization }
    let(:task) { create :task, organization: organization, projects: [project] }
    let(:user) { create :user, :organized, organization: organization }
    let(:time_entry_params) { {
      project_id:          project.id,
      task_id:             task.id,
      executed_on:         Date.today,
      user_id:             user.id,
      minutes_in_distance: '1'
    } }

    def call_action
      post :create, params: {
        organization_id: organization.id,
        time_view_id:    time_view_id,
        time_entry:      time_entry_params
      }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      before do
        sign_in user
        call_action
      end

      context 'and time_entry data is valid' do
        it { is_expected.to respond_with :redirect }
        it 'creates a new time_entry' do
          expect(assigns[:time_entry]).to be_persisted
          expect(organization.time_entries.count).to eq 1
        end
      end

      context 'and time_entry data is invalid' do
        let(:time_entry_params) { { name: '' } }

        it { is_expected.to render_template 'new' }
      end
    end
  end

  describe 'GET edit' do
    let(:time_entry_user) { create :user, :organized, organization: organization }
    let(:time_entry) { create :time_entry, organization: organization, user: time_entry_user }
    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }

    def call_action
      get :edit, params: { organization_id: organization.id, time_view_id: time_view_id, id: time_entry.id }
    end

    include_examples 'authentication'

    context 'when org user accesses their own entry' do
      before do
        sign_in time_entry_user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :edit }

      it 'assigns the time_entry' do
        expect(assigns[:time_entry]).to eq time_entry
      end
    end

    context 'when org user accesses other user entry' do
      let(:time_entry) { create :time_entry, organization: organization }

      it 'forbids access' do
        sign_in time_entry_user
        expect { call_action }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context 'when org admin accesses other user entry' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }
      let(:time_entry) { create :time_entry, organization: organization }

      it 'grants access' do
        sign_in user
        expect { call_action }.not_to raise_error
      end
    end
  end

  describe 'PUT update' do
    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
    let(:time_entry_user) { create :user, :organized, organization: organization }
    let(:time_entry) { create :time_entry, organization: organization, user: time_entry_user }
    let(:time_entry_params) { { minutes_in_distance: '10' } }

    def call_action
      put :update, params: {
        organization_id: organization.id,
        time_view_id:    time_view_id,
        id:              time_entry.id,
        time_entry:      time_entry_params
      }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      before do
        sign_in time_entry_user
        call_action
      end

      context 'and time_entry data is valid' do
        it { is_expected.to respond_with :redirect }

        it 'update the time_entry' do
          expect(assigns[:time_entry]).to be_persisted
          expect { time_entry.reload }.to change(time_entry, :amount).to 600
        end
      end

      context 'and time_entry data is invalid' do
        let(:time_entry_params) { { minutes_in_distance: '' } }

        it { is_expected.to render_template 'edit' }
      end
    end
  end

  describe 'DELETE destroy' do
    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
    let(:time_entry_user) { create :user, :organized, organization: organization }
    let(:time_entry) { create :time_entry, organization: organization, user: time_entry_user }

    def call_action
      delete :destroy, params: {
        organization_id: organization.id,
        time_view_id:    time_view_id,
        id:              time_entry.id
      }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      before do
        sign_in time_entry_user
        call_action
      end

      it 'deletes the entry' do
        expect { time_entry.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
