class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :rating, dependent: :destroy, as: :ratingable
  has_many :votes, dependent: :destroy, as: :votable
  has_one :achievement
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :achievement, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }

  def mark_best_answer(answer)
    achievement.user= answer.author if achievement
    self.best_answer= answer
    self.save
  end

  def account_vote(user, variant)
    new_vote = votes.new(vote: variant)
    new_vote.user = user
    new_vote.save
  end
end
