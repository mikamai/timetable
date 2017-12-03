# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboard#index'
    resources :organizations, except: :delete
  end

  devise_for :users
  resources :organizations, only: [] do
    resources :projects, only: %i[show edit update]
  end
  resources :projects, only: %i[index new create]
  root to: 'welcome#index'
end
