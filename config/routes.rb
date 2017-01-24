Rails.application.routes.draw do
  root 'stories#index'
  get 'landing', to: 'static#landing'
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'users/new_guest', to: 'users#new_guest', as: 'new_guest'
  post 'users/create_guest', to: 'users#create_guest', as: 'create_guest'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'blocked_users', to: 'relationships#blocked_users'
  get 'users/all_users', to: 'users#all_users', as: 'all_users'
  resources :users
  resources :stories
  resources :relationships
  resources :categories
end
