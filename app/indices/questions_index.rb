ThinkingSphinx::Index.define :question, with: :active_record do
  #fileds
  indexes title, sortable: true
  indexes body
  indexes author.email, as: :author, sortable: true

  # attributes
  has user_id, created_at, updated_at
  has rating.rating
end