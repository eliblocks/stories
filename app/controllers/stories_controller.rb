class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def index
    @stories = current_user.unblocked_stories.sorted_pages(params)
    @categories = Category.all
  end

  def show

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

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :body, :description, :category_id)
  end


end
