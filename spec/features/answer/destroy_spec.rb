require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Автор может удалить свой ответ, но не может удалить чужой ответ', %q(
  Чтобы избавиться от ненужного ответа
  Автор ответа
  Может может удалить ответ
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user, body: 'Bad comment') }
  given(:other_answer) { create(:answer) }

  describe 'Аутентифицированный пользователь пытается удалить вопрос' do
    background { login(user) }

    scenario 'являясь автором вопроса', js: true do
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Bad comment'
        accept_confirm do
          click_on 'Delete answer'
        end
        expect(page).to_not have_content 'Bad comment'
      end
    end

    scenario 'не являясь автором вопроса' do
      visit question_path(other_answer.question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Не аутентифицированный пользователь пытается удалить вопрос' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end
# rubocop:enable Style/RedundantPercentQ
