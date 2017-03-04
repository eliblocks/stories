class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    if logged_in?
      @users = current_user.unblocked_writers.order(favorites_count: :desc).limit(display_limit)
      @relationships = Relationship.where(follower_id: current_user.id, followed_id: @users.ids)
    else
      @users = User.writers.order(favorites_count: :desc).limit(display_limit)
    end
  end

  def blocked
    redirect_to login_path unless logged_in?
    @users = current_user.blocking.joins(:passive_relationships).where(relationships: { follower_id: current_user.id} )
    @relationships = Relationship.where(follower_id: current_user.id, followed_id: @users.ids)
    render 'index'
  end

  def show
    @email = @user.email
    @first_name = @user.first_name
    @age_group = @user.age_group
    @stories = @user.stories.sorted_pages(params)
    @relationship = current_user.active_relationship(@user)
  end

  def all_users
    @users = User.all.order(favorites_count: :desc)
    @relationships = Relationship.where(follower_id: current_user.id, followed_id: @users.ids)
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

  #Ensure records in multiples of 5 for layout reasons
  def display_limit
    if logged_in?
      num_unblocked = current_user.unblocked_writers.count
    else
      return 100
    end
    if num_unblocked < 100
      return num_unblocked - (num_unblocked % 5)
    else
      return 100
    end
  end
end
