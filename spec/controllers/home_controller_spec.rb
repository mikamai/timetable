# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET index' do
    context 'when user is not logged in' do
      before { get :index }

      it { is_expected.to respond_with :ok }
    end

    context 'when user is logged in with no organizations' do
      let(:user) { create :user, admin: true }

      before do
        sign_in user
        get :index
      end

      it { is_expected.to redirect_to new_organization_path }
    end

    context 'when user is logged in and is part of one organization' do
      let(:organization) { create :organization }
      let(:user) { create :user, :organized, organization: organization }

      before do
        sign_in user
        get :index
      end

      it { is_expected.to redirect_to organization_path(organization) }
    end
  end
end
