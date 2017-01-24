class SessionsController < ApplicationController

  def new
    redirect_to '/auth/facebook'
  end

  def create
    @auth = request.env['omniauth.auth']
    if User.find_by(email: @auth.info.email)
      @user = User.find_by(email: @auth.info.email)
      @user.process(@auth)
      @user.save
    else
      @user = User.new
      @user.process(@auth)
      @user.save
    end
    reset_session
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end



  def destroy
    reset_session
    redirect_to root_url
  end


end
