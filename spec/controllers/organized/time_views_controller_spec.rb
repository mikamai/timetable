# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::TimeViewsController do
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
      before do
        sign_in create :user, :organized, organization: organization
        Timecop.freeze Date.new(2018, 3, 12) do
          call_action
        end
      end

      it { is_expected.to redirect_to organization_time_view_path(organization, '2018-03-12') }
    end
  end

  describe 'GET show' do
    def call_action params = {}
      get :show, params: params.reverse_merge(organization_id: organization.id, id: '2018-03-12')
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :show }

      it 'assigns an object for the week_view' do
        week_view = assigns[:week_view]
        expect(week_view).to be_a WeekView
        expect(week_view.selected_id).to eq '2018-03-12'
        expect(week_view.organization).to eq organization
        expect(week_view.user).to eq user
      end
    end

    context 'when org user accesses the view of another user' do
      let(:user) { create :user, :organized, organization: organization }
      let(:another_user) { create :user, :organized, organization: organization }

      it 'forbids access' do
        sign_in user
        expect { call_action as: another_user.id }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context 'when org admin accesses the view of another user' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }
      let(:another_user) { create :user, :organized, organization: organization }

      it 'access is allowed' do
        sign_in user
        call_action as: another_user.id
        expect(assigns[:week_view].user).to eq another_user
      end
    end
  end
end
