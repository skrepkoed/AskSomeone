class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :achievement, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :achievement, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }

  def mark_best_answer(answer_id)
    update(best_answer_id: answer_id)
  end
end
