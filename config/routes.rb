# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  devise_for :users, controllers: {
    invitations: 'users/invitations',
    omniauth_callbacks: 'users/omniauth_callbacks'
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
        patch 'update_role/:role', on: :member, action: :update_role, as: :update_role
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
      resources :time_off_entries, only: %i[index new create update]
      get 'time_off_entries/:id/approve', controller: :time_off_entries, action: :approve, as: :approve_time_off_entry
      get 'time_off_entries/:id/decline', controller: :time_off_entries, action: :decline, as: :decline_time_off_entry
      resources :time_off_periods, only: %i[create]
      get 'time_off_periods/:id/approve', controller: :time_off_periods, action: :approve, as: :approve_time_off_period
      get 'time_off_periods/:id/decline', controller: :time_off_periods, action: :decline, as: :decline_time_off_period
    end
  end

  namespace :api do
    get 'me', controller: :api, action: :me, as: :me
    get 'me/orgs', controller: :organizations, action: :me, as: :me_orgs
    get 'me/projects', controller: :projects, action: :me, as: :me_projects
    get 'me/tasks', controller: :tasks, action: :me, as: :me_tasks
    resources :organizations, only: [], path: 'orgs' do
      resources :users, only: [] do
        resources :time_views, only: [], path: :time do
          resources :time_entries, only: %i[index], path: :entries
          resources :projects, only: [] do
            get 'entries', controller: :time_entries, action: :index_project, as: :time_entries_project
            resources :time_entries, only: :create, path: :entries
          end
        end
        resources :time_entries, only: %i[edit update destroy], path: :entries
      end
    end
  end

  resources :organizations, only: %i[new create]

  get 'no_organization' => 'home#no_organization'
  root to: 'home#index'
end