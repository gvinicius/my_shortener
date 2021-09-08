# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  namespace :api do
    namespace :v1 do
      resources :links, defaults: { format: 'json' }
    end
  end

  root to: 'home#landing'
  get 'home/landing'
  get 'home/redirect_shortened'
  match 'links/:id' => 'links#show', via: :get
  get 'service-worker(.format)', to: 'home#service_worker'
  match '/:path' => 'home#redirect_shortened', via: :get, as: :fallback
end
