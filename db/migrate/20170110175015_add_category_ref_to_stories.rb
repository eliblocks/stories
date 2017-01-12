class AddCategoryRefToStories < ActiveRecord::Migration[5.0]
  def change
    add_reference :stories, :category, index: true, foreign_key: true
  end
end
