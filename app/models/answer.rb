class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :author, class_name:'User', foreign_key:'user_id'

  validates :body, presence: true
end
