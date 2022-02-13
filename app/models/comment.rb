class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo_image

   validates :comment, presence: true

end
