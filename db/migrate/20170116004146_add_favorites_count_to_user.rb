class AddFavoritesCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :favorites_count, :integer
    add_column :users, :blocks_count, :integer
  end
end
