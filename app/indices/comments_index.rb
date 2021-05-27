ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body 
  indexes author.email, as: :author, sortable: true

  has created_at, updated_at, commentable_id, commentable_type, user_id 
end