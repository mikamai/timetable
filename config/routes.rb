# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root to: 'dashboard#index'
    resources :organizations, except: :delete do
      resources :organization_members, path: :members, only: :create do
        patch :toggle_admin, on: :member
      end
    end
  end

  scope module: 'organized' do
    resources :organizations, only: :show, path: 'orgs', controller: 'home' do
      resources :clients
      resources :organization_members, path: :members, only: %i[index new create destroy] do
        patch :toggle_admin, on: :member
      end
      resources :projects do
        resources :project_members, path: :members, only: :create
        post :add_task, on: :member, as: :add_task
        delete 'remove_task/:task_id', on: :member, action: :remove_task, as: :remove_task
      end
      resources :reports, only: %i[index show]
      resources :tasks, only: %i[index create]
      resources :time_views, only: %i[index show], path: :time do
        resources :time_entries, only: %i[new create], path: :entries
      end
      resources :time_entries, only: %i[edit update], path: :entries
    end
  end

  get 'profile' => 'profile#edit'
  patch 'profile' => 'profile#update'

  get 'no_organization' => 'home#no_organization'
  root to: 'home#index'
end
