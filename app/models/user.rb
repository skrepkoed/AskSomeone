class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions
  has_many :answers
  has_many :achievements

  def associate_achievement(achievement)
    if achievement
      achievements << achievement
    end
  end

  def author?(resource)
    resource.user_id == id
  end
end
