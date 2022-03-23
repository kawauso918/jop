class PhotoImage < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :tag_photos, dependent: :destroy
  has_many :tags, through: :tag_photos
  attachment :image
  is_impressionable
  geocoded_by :address
  after_validation :geocode

  validates :name, presence: true
  validates :image, presence: true
  validates :caption, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def create_notification_by(current_user)
      # 自分には通知がこないようにする
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

  def save_tags(tags)
    tag_list = tags.split(/[[:blank:]]+/)
    current_tags = self.tags.pluck(:name)
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags
    p current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_photo_image_tag = Tag.find_or_create_by(name: new)
      self.tags << new_photo_image_tag
    end
  end



end