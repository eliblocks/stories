class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize
  helper_method :current_user
  helper_method :logged_in?

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    User.find(session[:user_id])
  end

  def authorize
    unless [root_url, login_url].include?(request.url) ||
            logged_in? ||
            request.env['omniauth.auth']
      redirect_to root_url
    end
  end
end
