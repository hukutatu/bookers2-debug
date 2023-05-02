class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   validates :name, uniqueness: true, length: { minimum: 2, maximum: 20 }
   has_many :books, dependent: :destroy
   has_one_attached :profile_image
   has_many :favorites, dependent: :destroy
   has_many :book_comments, dependent: :destroy
   
   has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
   has_many :following_user, through: :follower, source: :followed

   has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
   has_many :follower_user, through: :followed, source: :follower



  validates :name, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

   def get_profile_image
        (profile_image.attached?) ? profile_image : 'no_image.jpg'
   end

   def follow(user_id)
    follower.create(followed_id: user_id)
   end

#　フォローを外すときの処理
   def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
   end

  #フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end
