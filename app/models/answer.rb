class Answer < ApplicationRecord
  include Authorable
  include Votable
  include Linkable
  include Commentable

  belongs_to :question

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: {message: "Answer can't be blank"}

  after_commit :send_notification, on: :create

  def select_best!
    Answer.transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end

  private

  def send_notification
    AnswerNotificationJob.perform_later(self)
  end
end
