class AddColumnsToPhotoImages < ActiveRecord::Migration[5.2]
  def change
    add_column :photo_images, :address, :string
    add_column :photo_images, :latitude, :float
    add_column :photo_images, :longitude, :float
  end
end
