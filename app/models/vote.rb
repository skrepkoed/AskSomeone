class Vote < ApplicationRecord
  belongs_to :votable, polymorphic:true
  belongs_to :user

  validates_uniqueness_of :votable_type, scope:[:votable_id, :user_id]
end
