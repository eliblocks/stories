class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:create, :edit, :update, :destroy, :new]
  before_action :authorize_writer, only: [:edit, :update, :destroy]
  before_action :set_current_user

  def index
    if logged_in?
      @stories = @current_user.unblocked_stories.sorted_pages(params)
      following_ids = @current_user.following.where(id: @stories.pluck(:user_id)).pluck(:id)
      @following = User.where(id: following_ids)
      @relationships = @current_user.active_relationships.where(followed_id: following_ids )
    else
      @stories = Story.all.sorted_pages(params)
    end
    @categories = Category.all
  end

  def show
    if following_object(@story.user)
      @relationship = @current_user.active_relationship(@story.user)
    end
  end

  def new
    @story = Story.new
  end

  def create
    @story = @current_user.stories.new(story_params)
    if @story.save
      flash[:success] = "Story successfully created"
      redirect_to stories_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @story.update(story_params)
      flash[:success] = "Story successfully edited"
      redirect_to story_path(@story)
    else
      render 'edit'
    end

  end

  def destroy
    @story.destroy
    flash[:success] = "Story successfully deleted"
    redirect_to request.referrer || root_url
  end

  def relationship(story)
    if show? && following?(story)
      @relationship = @relationships.find_by(story_id: story.id)
    elsif following?(story)
      @relationship
    end
  end


  def following_object?(story)
    if show?
      @current_user.following?(story.user)
    else
      @following.include?(story.user)
    end
  end


  private

  def show?
    params[:action] == "show"
  end

  def index
    params[:action] == "index"
  end

  def set_current_user
    @current_user = current_user
  end

  def set_story
    @story = Story.find(params[:id])
  end

  def authorize_writer
    redirect_to root_path unless @story.user == current_user
  end

  def story_params
    params.require(:story).permit(:title, :body, :description, :category_id)
  end
end
