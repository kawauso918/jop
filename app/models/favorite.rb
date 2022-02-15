class Favorite < ApplicationRecord
  belongs_to  :user
  belongs_to  :photo_image
  has_many :notifications, dependent: :destroy

end
