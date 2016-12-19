class AuthController < ApplicationController

  def facebook
    redirect_to after_redirect_url
    flash[:notice] = "correct URL!"
  end
end
