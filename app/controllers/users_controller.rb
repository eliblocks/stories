class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = current_user.unblocked_writers.order(favorites_count: :desc).limit(100)
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

  def new_guest
    @user = User.new
  end

  def create_guest
    if User.find_by(email: params[:user][:email])
      @user = User.find_by(email: params[:user][:email])
    else
      @user = User.new(user_params)
      @user.name = user_params[:first_name] + ' ' + user_params[:last_name]
      @user.save
    end
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
