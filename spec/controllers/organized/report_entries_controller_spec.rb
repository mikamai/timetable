# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::ReportEntriesController do
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

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :index }

      it 'does not include entries of other organizations' do
        expect(assigns[:time_entries]).to be_empty
      end

      it 'does not include entries of other users' do
        create :time_entry, organization: organization
        expect(assigns[:time_entries]).to be_empty
      end

      it 'includes entries made by the user' do
        time_entry = create :time_entry, organization: organization, user: user
        expect(assigns[:time_entries].to_a).to eq [time_entry]
      end
    end

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :index }

      it 'does not include entries of other organizations' do
        expect(assigns[:time_entries]).to be_empty
      end

      it 'includes all organization entries' do
        time_entry = create :time_entry, organization: organization
        expect(assigns[:time_entries].to_a).to eq [time_entry]
      end
    end
  end
end
