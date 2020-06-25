class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :user_id, :body, :best, :created_at, :updated_at, :rating
end
