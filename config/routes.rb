Rails.application.routes.draw do
  mount Peek::Railtie => '/peek'
  root 'stories#index'
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'blocked', to: 'users#blocked', as: 'blocked'
  get 'search', to: 'stories#search', as: 'search'
  #get 'users/all_users', to: 'users#all_users', as: 'all_users'
  get '/stories/favorites', to: 'stories#favorites', as: 'favorites'
  get 'requirements', to: 'static#requirements', as: 'requirements'
  post '/relationships/vote', to: 'relationships#vote', as: 'vote'
  resources :users
  resources :stories
  resources :relationships
  resources :categories
end
