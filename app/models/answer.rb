class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :links, as: :linkable, dependent: :delete_all

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: {message: "Answer can't be blank"}

  def select_best!
    Answer.transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
