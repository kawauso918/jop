class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness:true, length: {minimum: 2, maximum:20 }
  attachment :profile_image

  has_many :photo_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

   # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_follows, source: :follower
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :follows, source: :followed

  def follow(user_id)
    follows.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follows.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

end
