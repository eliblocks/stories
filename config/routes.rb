Rails.application.routes.draw do
  root 'static#index'
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  resources :users
  resources :stories
end
