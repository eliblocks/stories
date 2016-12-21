class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :facebook_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :age_range
      t.string :link
      t.string :gender
      t.string :locale
      t.string :image
      t.string :picture
      t.string :timezone
      t.datetime :updated_time
      t.boolean :verified
      t.string :email

      t.timestamps
    end
  end
end
