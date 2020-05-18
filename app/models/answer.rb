class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: {message: "Answer can't be blank"}
end
