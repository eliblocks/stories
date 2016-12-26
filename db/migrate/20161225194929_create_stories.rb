class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.text :description
      t.text :body
      t.references :user

      t.timestamps
    end
  end
end
