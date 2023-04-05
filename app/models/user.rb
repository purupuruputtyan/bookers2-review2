class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

#==============================自分をフォローしているユーザーとの関連==========================
  #自分がフォローされる側の関係性(自分はフォローしていない)
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #自分をフォローしている人(自分はフォローしていない)
  has_many :followers, through: :reverse_of_relationships, source: :follower#sourceはモデルの参照元
#==================================================================================================

#==============================自分がフォローするユーザーとの関連=================================
  #自分がフォローする側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
#====================================================================================================

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def follow(user)#current_userに所属していると言う意味
    relationships.create(followed_id: user.id)
    #current_user.relationships.create(followed_id: user.id)
    #Relationship.create(followed_id:user.id, user_id:current_user.id)
  end

  def unfollow(user)#current_usesrに所属していると言う意味
    relationships.find_by(followed_id: user.id).destroy
    #Relationship.find_by(followed_id:user.id, user_id:current_user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

end
