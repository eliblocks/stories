class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :current_user
  helper_method :logged_in?

  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    User.find(session[:user_id])
  end

  def authenticate_user
    redirect_to login_path unless logged_in?
  end
end
