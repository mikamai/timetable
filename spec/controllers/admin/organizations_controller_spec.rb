# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::OrganizationsController, type: :controller do
  it 'raises error if user is not logged in' do
    get :index
    expect(response).to redirect_to new_user_session_path
  end

  it 'raises a NotFound if user is logged in but not admin' do
    user = create :user
    sign_in user
    expect { get :index }.to raise_error ActionController::RoutingError
  end
end
