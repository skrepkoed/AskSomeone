ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body
  indexes author.email, as: :author, sortable: true
  
  has created_at, updated_at, question_id, user_id
  has rating.rating
end