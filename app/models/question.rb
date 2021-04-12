class Question < ApplicationRecord
  has_many :answers
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }
end
