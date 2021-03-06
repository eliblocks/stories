class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:create, :edit, :update, :destroy, :new]
  before_action :authorize_writer, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:index, :favorites, :search]

  def index
    if logged_in?
      @stories = current_user.unblocked_stories.includes(:user).page(params[:page])
      @relationships = Relationship.where(follower_id: current_user.id, story_id: @stories.collect(&:id))
    else
      @stories = Story.all.page(params[:page])
    end
    filter_by_category
  end

  def favorites
    redirect_to login_path unless logged_in?
    @stories = current_user.favorite_stories.includes(:user).page(params[:page])
    @relationships = Relationship.where(follower_id: current_user.id,
                                        followed_id: @stories.collect { |story| story.user.id})
    filter_by_category
    render 'index'
  end

  def show
    @relationship = current_user.active_relationship(@story.user) if current_user
  end

  def new
    @story = Story.new
  end

  def create
    @story = current_user.stories.new(story_params)
    if @story.save
      flash[:success] = "Story successfully created"
      redirect_to stories_path
    else
      render 'new'
    end
  end

  def edit
  end

  def search
    @term = params[:term]
    @stories = Story.search(@term)
    render 'index'
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

  private

  def filter_by_category
    @stories = @stories.where(category_id: params[:category]) if params[:category]
  end

  def set_story
    @story = Story.find(params[:id])
  end

  def authorize_writer
    redirect_to root_path unless @story.user == current_user
  end

  def story_params
    params.require(:story).permit(:title, :body, :description, :category, :category_id)
  end

  def set_categories
    @categories = Category.all
  end
end
