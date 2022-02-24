class PhotoImage < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  attachment :image
  is_impressionable

  validates :name, presence: true
  validates :image, presence: true
  validates :caption, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def create_notification_by(current_user)
        notification = current_user.active_notifications.new(photo_image_id: id, visited_id: user_id, action: "favorite")
        if notification.visitor_id == notification.visited_id
        notification.checked = true
        end
          notification.save
        if notification.valid?
        end
  end

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(photo_image_id: id, visited_id: user_id, action: 'comment')
    # 自分には通知がこないようにする
    if notification.visitor_id == notification.visited_id
        notification.checked = true
    end
      notification.save
    if notification.valid?
    end
  end

end