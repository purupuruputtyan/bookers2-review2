class Group < ApplicationRecord
  has_one_attached :image
  belongs_to :owner, class_name: 'User'
  has_many :group_users, dependent: :destroy

  validates :name, presence: true
  validates :introduction, presence: true

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def is_owned_by?(user)
    owner.id == user.id
  end

end
