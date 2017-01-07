Rails.application.routes.draw do
  root 'stories#index'
  get 'landing', to: 'static#landing'
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'blocked_users', to: 'relationships#blocked_users'
  resources :users
  resources :stories
  resources :relationships
end
