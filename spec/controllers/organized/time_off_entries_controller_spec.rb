# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::TimeOffEntriesController do
  let(:organization) { create :organization }

  shared_examples 'authentication' do
    context 'when user is not logged in' do
      before { call_action }

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user has no access to the current organization' do
      let(:no_user) { create :user, admin: true }

      it 'raises a 404' do
        sign_in no_user
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET new' do
    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }

    def call_action
      get :new, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let!(:user) { create :user, :organized, organization: organization }
      let!(:project) { create :project, organization: organization, users: [user] }
      let!(:task) { create :task, projects: [project], organization: organization }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a newly built time_off_entry' do
        expect(assigns[:time_off_entry]).to be_a TimeOffEntry
        expect(assigns[:time_off_entry]).to be_new_record
      end
    end
  end

  describe 'POST create' do
    let!(:user) { create :user, :organized, organization: organization }

    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
    let(:time_off_entry_params) { {
      executed_on: Date.today,
      user_id:     user.id,
      time_amount: '1',
      typology: 'paid',
      notes: 'asd'
    } }

    def call_action
      post :create, params: {
        organization_id: organization.id,
        time_off_entry:  time_off_entry_params
      }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      before do
        sign_in user
        call_action
      end

      context 'and time_off_entry data is valid' do
        it { is_expected.to respond_with :redirect }

        it 'creates a new time_off_entry' do
          expect(assigns[:time_off_entry]).to be_persisted
          expect(organization.time_off_entries.count).to eq 1
        end
      end

      context 'and time_off_entry data is invalid' do
        let(:time_off_entry_params) { { name: '' } }

        it { is_expected.to render_template 'new' }
      end
    end
  end
end
