class PhotoImage < ApplicationRecord
  belongs_to  :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  attachment :image

  validates :name, presence: true
  validates :image, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end