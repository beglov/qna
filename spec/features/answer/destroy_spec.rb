require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Автор может удалить свой ответ, но не может удалить чужой ответ', %q(
  Чтобы избавиться от ненужного ответа
  Автор ответа
  Может может удалить ответ
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  describe 'Аутентифицированный пользователь пытается удалить вопрос' do
    scenario 'являясь автором вопроса' do
      login(answer.user)

      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content 'Answer was successfully deleted.'
    end

    scenario 'не являясь автором вопроса' do
      login(user)

      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content 'Delete unavailable! You are not the author of the answer.'
    end
  end

  scenario 'Не аутентифицированный пользователь пытается удалить вопрос' do
    visit answer_path(answer)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
# rubocop:enable Style/RedundantPercentQ
