Rails.application.routes.draw do
  resources :links

  root 'links#index'

  match '*path' => 'links#show', via: :get
end
