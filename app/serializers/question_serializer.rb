class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  belongs_to :user
  has_many :answers

  def short_title
    object.title.truncate(5)
  end
end
