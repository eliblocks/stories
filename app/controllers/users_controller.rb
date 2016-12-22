class UsersController < ApplicationController
  before_action :set_user, only: [:show]


  def index
    @users = User.all
  end

  def show
    @email = @user.email
    @first_name = @user.first_name
    @age_group = @user.age_group
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
