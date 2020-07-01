ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email

  # attributes
  has created_at
end
