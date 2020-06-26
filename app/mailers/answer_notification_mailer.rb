class AnswerNotificationMailer < ApplicationMailer
  def create_notification(answer, user)
    @answer = answer

    mail to: user.email
  end
end
