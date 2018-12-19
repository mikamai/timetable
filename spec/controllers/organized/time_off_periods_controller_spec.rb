# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::TimeOffPeriodsController do
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

  describe 'POST create' do
    let!(:user) { create :user, :organized, organization: organization }

    let(:time_view_id) { Date.today.strftime TimeView::ID_FORMAT }
    let(:time_off_period_params) { {
      start_date: Date.today,
      end_date: Date.tomorrow,
      user_id: user.id,
      typology: 'vacation'
    } }

    def call_action
      post :create, params: {
        organization_id: organization.id,
        time_off_period:  time_off_period_params
      }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      before do
        sign_in user
        call_action
      end

      context 'and time_off_period data is valid' do
        it { is_expected.to respond_with :redirect }

        it 'creates a new time_off_period' do
          expect(assigns[:time_off_period]).to be_persisted
          expect(organization.time_off_periods.count).to eq 1
        end
      end
    end
  end
end
