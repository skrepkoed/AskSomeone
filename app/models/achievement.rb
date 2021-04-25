class Achievement < ApplicationRecord
  belongs_to :question
  has_one_attached :file, dependent: :destroy
end
