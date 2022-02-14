class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo_image
  has_many :notifications, dependent: :destroy
  validates :comment, presence: true
end
