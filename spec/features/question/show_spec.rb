require 'rails_helper'

feature 'User can show question and his answers' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User viewing question and his answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
