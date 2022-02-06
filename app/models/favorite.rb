class Favorite < ApplicationRecord
  belongs_to  :user
  belongs_to  :photo_images

end
