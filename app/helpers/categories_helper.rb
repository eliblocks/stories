module CategoriesHelper

  def state(category)
    params[:id] == category.id.to_s ? " active" : ""
  end
end
