class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }

  def mark_best_answer(answer_id)
    update(best_answer_id: answer_id)
  end
end
