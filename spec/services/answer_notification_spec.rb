require 'rails_helper'

RSpec.describe Services::AnswerNotification do
  let(:author_question) { create(:user) }
  let(:question) { create(:question, user: author_question) }
  let(:other_user) { create(:user) }
  let!(:subscription) { create(:subscription, question: question, user: other_user) }
  let(:answer) { create(:answer, question: question) }

  it 'sends create answer notification to all subscribed users' do
    expect(AnswerNotificationMailer).to receive(:create_notification).with(answer, author_question).and_call_original
    expect(AnswerNotificationMailer).to receive(:create_notification).with(answer, other_user).and_call_original
    Services::AnswerNotification.send_create_notification(answer)
  end
end
