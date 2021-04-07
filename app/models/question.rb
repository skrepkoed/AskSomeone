class Question < ApplicationRecord
	has_many :answers

  validates  :title, :body, presence: true
  validates :body, length: { minimum: 5 }
end