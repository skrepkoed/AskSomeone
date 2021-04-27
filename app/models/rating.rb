class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true

  def pro
    self.rating+=1
  end
end
