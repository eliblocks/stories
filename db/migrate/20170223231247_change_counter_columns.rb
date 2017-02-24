class ChangeCounterColumns < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :favorites_count, false
    change_column_null :users, :blocks_count, false
    change_column_null :stories, :favorites_count, false
    change_column_null :stories, :blocks_count, false
    change_column_default :users, :favorites_count, from: nil, to: 0
    change_column_default :users, :blocks_count, from: nil, to: 0
    change_column_default :stories, :favorites_count, from: nil, to: 0
    change_column_default :stories, :blocks_count, from: nil, to: 0
  end
end
