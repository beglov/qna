require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь, находясь на странице вопроса, может написать ответ на вопрос', %q(
  Чтобы помочь решить проблему
  Аутентифицированный пользователь
  Может написать ответ на вопрос
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Аутентифицированный пользователь' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'пишет ответ на вопрос' do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Reply'

      expect(page).to have_content 'Your answer added'
      expect(page).to have_content 'Test answer'
    end

    scenario 'пишет ответ на вопрос с ошибками' do
      click_on 'Reply'

      expect(page).to have_content "Answer can't be blank"
    end
  end

  scenario 'Не аутентифицированный пользователь пытается ответить на вопрос' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
# rubocop:enable Style/RedundantPercentQ
