# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  devise_for :users, controllers: {
    invitations: 'users/invitations'
  }

  namespace :admin do
    resources :users, only: :index
  end

  scope module: 'organized' do
    resources :organizations, only: :show, path: 'orgs', controller: 'home' do
      resources :clients
      resources :organization_members, path: :members, only: %i[index new create destroy] do
        patch :toggle_admin, on: :member
      end
      resources :projects, except: %i[show destroy]

      resources :report_summaries, only: :index do
        member do
          get :clients
          get :projects
          get :tasks
          get :team
        end
      end

      get 'report_entries' => 'report_entries#index', as: :report_entries

      resources :roles
      resources :tasks, only: %i[index new create edit update]
      resources :time_views, only: %i[index show], path: :time do
        resources :time_entries, only: %i[new create], path: :entries
      end
      resources :time_entries, only: %i[edit update], path: :entries
    end
  end

  resources :organizations, only: %i[new create]

  get 'no_organization' => 'home#no_organization'
  root to: 'home#index'
end
