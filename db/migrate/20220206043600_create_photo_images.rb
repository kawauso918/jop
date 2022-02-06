class CreatePhotoImages < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_images do |t|
      t.string :name
      t.string :image_id
      t.text :caption
      t.integer :user_id

      t.timestamps
    end
  end
end
