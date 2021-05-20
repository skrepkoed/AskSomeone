class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :rating, dependent: :destroy, as: :ratingable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_and_belongs_to_many :subscribers, join_table:'subscriptions', class_name:'User'
  has_one :achievement, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :achievement, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }

  scope :today_questions, -> { where(created_at: Time.now.midnight...(Time.now.midnight+1.day)) }

  after_create :subscribe

  def mark_best_answer(answer)
    achievement.user = answer.author if achievement
    self.best_answer = answer
    save
  end

  def subscribe
    subscriptions.create(user: self.author)
  end
end
