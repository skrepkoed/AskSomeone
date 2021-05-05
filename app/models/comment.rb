class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic:true
  belongs_to :author, class_name:'User', foreign_key: 'user_id'

  #validates :body, presence: true

  def question
    if commentable_type == 'Question'
      self.commentable
    elsif commentable_type == 'Answer'
      self.commentable.question
    end
  end
end
