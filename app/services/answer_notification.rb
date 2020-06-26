class Services::AnswerNotification
  def self.send_create_notification(answer)
    answer.question.subscriptions.each do |subscription|
      AnswerNotificationMailer.create_notification(answer, subscription.user).deliver_later
    end
  end
end
