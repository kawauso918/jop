class PhotoImage < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :tag_photos, dependent: :destroy
  has_many :tags, through: :tag_photos
  attachment :image
  is_impressionable

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

    # タグをスペース区切りで分割し配列にする
    #   連続した空白も対応するので、最後の“+”がポイント
    tag_list = tags.split(/[[:blank:]]+/)

    # 自分自身に関連づいたタグを取得する
    current_tags = self.tags.pluck(:name)

    # (1) 元々自分に紐付いていたタグと投稿されたタグの差分を抽出
    #   -- 記事更新時に削除されたタグ
    old_tags = current_tags - tag_list

    # (2) 投稿されたタグと元々自分に紐付いていたタグの差分を抽出
    #   -- 新規に追加されたタグ
    new_tags = tag_list - current_tags

    p current_tags

    # tag_mapsテーブルから、(1)のタグを削除
    #   tagsテーブルから該当のタグを探し出して削除する
    old_tags.each do |old|
      # tag_mapsテーブルにあるpost_idとtag_idを削除
      #   後続のfind_byでtag_idを検索
      self.tags.delete Tag.find_by(name: old)
    end

    # tagsテーブルから(2)のタグを探して、tag_mapsテーブルにtag_idを追加する
    new_tags.each do |new|
      # 条件のレコードを初めの1件を取得し1件もなければ作成する
      # find_or_create_by : https://railsdoc.com/page/find_or_create_by
      new_photo_image_tag = Tag.find_or_create_by(name: new)

      # tag_mapsテーブルにpost_idとtag_idを保存
      #   配列追加のようにレコードを渡すことで新規レコード作成が可能
      self.tags << new_photo_image_tag
    end
  end


end