class Favorite < ApplicationRecord
  belongs_to  :user
  belongs_to  :photo_image
  has_many :notifications, dependent: :destroy

  # def create_notification_by(current_user)
    # notification= current_user.active_notifications.new(favorite_id:self.id, visited_id:self.contributer.id,action:"favorite")
    # notification.save if notification.valid?
  # end
end
