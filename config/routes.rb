Rails.application.routes.draw do
  root 'static#index'
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'blocked_users', to: 'relationships#blocked_users'
  resources :users
  resources :stories
  resources :relationships
end
