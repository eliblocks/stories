class SessionsController < ApplicationController

  def create
    @auth = request.env['omniauth.auth']
    if User.find_by(email: @auth.info.email)
      @user = User.find_by(email: @auth.info.email)
    else
      @user = User.new
      @user.process(@auth)
      @user.save
    end
    debugger
    redirect_to root_url
  end
end
