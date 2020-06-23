class QuestionShowSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :user_id, :title, :body, :files, :created_at, :updated_at
  belongs_to :user
  has_many :comments
  has_many :links
  has_many :files

  def files
    object.files.map do |file|
      {
        name: file.filename.to_s,
        url: rails_blob_path(file, only_path: true)
      }
    end
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :user_id, :body, :created_at, :updated_at
  end
end
