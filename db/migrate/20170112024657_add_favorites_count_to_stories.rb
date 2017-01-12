class AddFavoritesCountToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :favorites_count, :integer
    add_column :stories, :blocks_count, :integer
  end
end
