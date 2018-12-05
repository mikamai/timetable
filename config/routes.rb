# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  devise_for :users, controllers: {
    invitations: 'users/invitations'
  }

  namespace :admin do
    resources :users, only: :index

    if Rails.env.production?
      authenticate :user, lambda { |u| u.admin? } do
        require 'sidekiq/web'
        require 'sidekiq-scheduler/web'
        mount Sidekiq::Web, at: '/sidekiq'
      end
    end
  end

  scope module: 'organized' do
    resources :organizations, only: :show, path: 'orgs', controller: 'home' do
      resources :clients
      resources :organization_members, path: :members, only: %i[index new create destroy] do
        patch :resend_invitation, on: :member
        patch :toggle_admin, on: :member
      end
      resources :projects

      resources :report_summaries, only: :index do
        member do
          get :clients
          get :projects
          get :tasks
          get :team
        end
      end

      get 'report_entries' => 'report_entries#index', as: :report_entries
      resources :report_entries_exports, path: 'report_entries/exports', only: %w[create show]

      resources :roles
      resources :tasks, only: %i[index new create edit update]
      resources :time_views, only: %i[index show], path: :time do
        resources :time_entries, only: %i[new create], path: :entries
      end
      resources :time_entries, only: %i[edit update destroy], path: :entries
      resources :time_off_entries, only: %i[index new create]
      resources :time_off_periods, only: %i[create]
    end
  end

  resources :organizations, only: %i[new create]

  get 'no_organization' => 'home#no_organization'
  root to: 'home#index'
end
