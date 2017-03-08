class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    if logged_in?
      @stories = unblocked_category_stories.sorted_pages(params)
    else
      @stories = @category.stories.sorted_pages(params)
    end
    render "stories/index"
  end

  def unblocked_category_stories
    @category = Category.find(params[:id])
    @category.stories.where.not(id: current_user.blocked_stories.ids)
  end
end
