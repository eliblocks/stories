class ChangeRelationshipColumnDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:relationships, :block, false)
  end
end
