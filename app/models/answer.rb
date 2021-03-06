class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :files
  has_one :rating, as: :ratingable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  before_destroy :nullify_best_answer, if: :best_answer?
  after_create :notify_about_answer

  def best_answer?
    question.best_answer&.id == id
  end

  def notify_about_answer
    QuestionNotifyJob.perform_later(self)
  end

  private

  def nullify_best_answer
    question.update(best_answer: nil)
  end
end
