class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = current_user.unblocked_writers.order(favorites_count: :desc)
  end

  def show
    @email = @user.email
    @first_name = @user.first_name
    @age_group = @user.age_group
    @stories = @user.stories.sorted_pages(params)
  end

  def all_users
    @users = User.all
    render 'index'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
