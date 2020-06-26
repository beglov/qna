class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.all

    mail to: user.email
  end
end
