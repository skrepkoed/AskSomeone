class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[github google_oauth2]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  scope :without_user, ->(user){ where.not(id:user.id) }

  def earned_achievements
    achievements.joins(:question).where.not(questions: { user_id: id })
  end

  def associate_achievement(achievement)
    achievements << achievement if achievement
  end

  def author?(resource)
    resource.user_id == id
  end

  def admin?
    admin
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
