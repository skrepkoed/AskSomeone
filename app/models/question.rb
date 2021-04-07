class Question < ApplicationRecord
	has_many :answers

  validates  :title, :body, :user_id, presence: true
  validates :body, length: { minimum: 5 }
end
