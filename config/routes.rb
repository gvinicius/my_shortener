Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :links
    end
  end

  root :to => 'home#landing'
  get 'home/landing'
  get 'home/redirect_shortned'
  match 'links/:id' => 'links#show', via: :get
  match '/:path' => 'home#redirect_shortned', via: :get, as: :fallback
end
