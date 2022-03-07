class Tag < ApplicationRecord
  has_many :tag_photos, dependent: :destroy, foreign_key: 'tag_id'
  has_many :photo_images, through: :tag_photos
end
