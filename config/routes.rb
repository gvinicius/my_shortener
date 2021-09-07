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
  get 'home/redirect_shortned'
  match 'links/:id' => 'links#show', via: :get
  match '/:path' => 'home#redirect_shortned', via: :get, as: :fallback
end
