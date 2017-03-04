class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    if logged_in?
      @users = current_user.unblocked_writers.order(favorites_count: :desc).limit(1000)
      @relationships = Relationship.where(follower_id: current_user.id, followed_id: @users.collect(&:id))
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
    @stories = @user.stories.sorted_pages(params)
    @relationship = current_user.active_relationship(@user) if current_user
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

end
