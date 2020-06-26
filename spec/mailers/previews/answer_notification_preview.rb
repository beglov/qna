# Preview all emails at http://localhost:3000/rails/mailers/answer_notification
class AnswerNotificationPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/answer_notification/create_notification
  def create_notification
    AnswerNotificationMailer.create_notification(Answer.first, User.first)
  end
end
