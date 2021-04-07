class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy

  validates :body, :user_id, :question_id, presence: true
end
