# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :organizations, except: :delete
  root to: 'welcome#index'
end
