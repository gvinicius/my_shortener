Rails.application.routes.draw do
  devise_for :users
  resources :links

  root 'links#index'

  match 'links/:id' => 'links#show', via: :get
  match '/:path' => 'application#redirect_shortned', via: :get, as: :fallback
end
