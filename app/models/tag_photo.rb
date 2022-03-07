class TagPhoto < ApplicationRecord
  belongs_to :photo_image
  belongs_to :tag

  # 念のためのバリデーション
  validates :photo_image_id, presence: true
  validates :tag_id, presence: true
end
