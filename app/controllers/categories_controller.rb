class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @stories = unblocked_category_stories.page(params[:page]).per(2)
    render "stories/index"
  end

  def unblocked_category_stories
    @category = Category.find(params[:id])
    @category.stories.where.not(id: current_user.blocked_stories.ids)
  end
end
