class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::AnswerNotification.send_create_notification(answer)
  end
end
