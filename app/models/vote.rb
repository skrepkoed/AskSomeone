class Vote < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :rating
  belongs_to :user

  before_update :unvote

  validate :impossible_to_vote_with_same_variant, on: :update
  validates_uniqueness_of :rating_id, scope: :user_id, message:'You can vote only once'
  
  def unvote
    if self.variant_changed?
      self.destroy
    end
  end

   def voted(variant)
    if self.variant == variant 
      "Voted"
    else
      "Revote"
    end
  end

  def account_vote(variant)
    self.variant = variant
    self.rating.rating += variant if self.save
    self
  end
  
  def impossible_to_vote_with_same_variant
    if !self.variant_changed?
      errors.add :variant, 'You can vote only once'
    end
  end
end
