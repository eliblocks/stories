Rails.application.routes.draw do
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  resources :users
  root 'static#index'
end
