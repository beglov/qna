require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Автор может удалить свой ответ, но не может удалить чужой ответ', %q(
  Чтобы избавиться от ненужного ответа
  Автор ответа
  Может может удалить ответ
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, body: 'Bad comment') }

  describe 'Аутентифицированный пользователь пытается удалить вопрос' do
    scenario 'являясь автором вопроса' do
      login(answer.user)

      visit question_path(answer.question)
      expect(page).to have_content 'Bad comment'
      click_on 'Delete answer'
      expect(page).to_not have_content 'Bad comment'
      expect(page).to have_content 'Answer was successfully deleted.'
    end

    scenario 'не являясь автором вопроса' do
      login(user)

      visit question_path(answer.question)
      expect(page).to_not have_content 'Delete answer'
    end
  end

  scenario 'Не аутентифицированный пользователь пытается удалить вопрос' do
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete answer'
  end
end
# rubocop:enable Style/RedundantPercentQ
