class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :body, :user_id, :best, :created_at, :updated_at, :rating
end
