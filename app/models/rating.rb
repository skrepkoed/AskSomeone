class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true
  has_many :votes, dependent: :destroy

  validates_uniqueness_of :ratingable_type, scope: :ratingable_id

  def voted?(user, variant)
    vote = find_user_vote(user)
    if vote.persisted?
      vote.voted(variant)
    else
      false
    end
  end

  def ratingable_resource
    ratingable_type.constantize.find(ratingable_id)
  end

  def find_user_vote(user)
    votes.find_by(user_id: user) || votes.new(user_id: user.id)
  end
end
