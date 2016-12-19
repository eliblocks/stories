Rails.application.routes.draw do
  get 'auth/facebook/callback', to: 'auth#facebook'
  root 'static#index'
  get '/after_redirect', to: 'static#after_redirect'
end
