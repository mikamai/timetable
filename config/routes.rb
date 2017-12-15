# frozen_string_literal: true

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
      resources :projects, except: :destroy

      get 'report_summaries' => 'report_summaries#index', as: :report_summaries
      get 'report_summaries/:id/:section' => 'report_summaries#show', as: :report_summary
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
