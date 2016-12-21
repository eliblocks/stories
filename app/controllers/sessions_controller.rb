class SessionsController < ApplicationController

  def create
    @auth = request.env['omniauth.auth']
    process(@auth)
    redirect_to root_url
  end
end
