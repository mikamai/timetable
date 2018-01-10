# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create :user }

  it 'requires user login' do
    get :index
    expect(response).to redirect_to new_user_session_path
  end

  it 'raises a NotFound if user is logged in but not admin' do
    sign_in user
    expect { get :index }.to raise_error Pundit::NotAuthorizedError
  end

  context 'when admin is logged in' do
    let(:user) { create :user, admin: true }
    before { sign_in user }

    it 'assigns all users' do
      get :index
      expect(assigns[:users]).to be_a ActiveRecord::Relation
      expect(assigns[:users].to_a).to eq User.all.to_a
    end

    it 'paginates users' do
      get :index
      expect(assigns[:users]).to respond_to :total_pages
    end
  end
end
