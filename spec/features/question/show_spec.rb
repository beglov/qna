require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может просматривать вопрос и ответы к нему', %q(
  Чтобы получить ответы
  Любой пользователь
  Может просматривать вопрос и ответы к нему
) do
  given(:question) { create(:question) }

  background do
    question.answers.create!(body: 'answer 1')
    question.answers.create!(body: 'answer 2')
  end

  scenario 'Пользователь просматривает вопрос и ответы к нему' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'Answers'
    expect(page).to have_content 'answer 1'
    expect(page).to have_content 'answer 2'
  end
end
# rubocop:enable Style/RedundantPercentQ
