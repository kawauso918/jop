class CreateTagPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_photos do |t|
      t.references :photo_image, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
