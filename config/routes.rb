# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboard#index'
    resources :organizations, except: :delete do
      resources :organization_memberships, path: :members, only: :create do
        patch :toggle_admin, on: :member
      end
    end
  end

  devise_for :users
  resources :organizations, only: [] do
    resources :projects, only: %i[show edit update]
  end
  resources :projects, only: %i[index new create]
  root to: 'welcome#index'
end
