class AddStoryRefToRelationships < ActiveRecord::Migration[5.0]
  def change
    add_reference :relationships, :story, index: true, foreign_key: true
  end
end
