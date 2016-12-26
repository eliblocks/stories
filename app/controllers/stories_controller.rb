class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :delete]

  def index
    @stories = Story.all
  end

  def show
  end

  def new
    @story = Story.new
  end

  def create
    @story = current_user.stories.create!(story_params)
    redirect_to stories_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :body, :description)
  end
end
