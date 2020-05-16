require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может создать вопрос', %q(
  Для того чтобы получить ответ от сообщества
  Аутентифицированный пользователь
  Может задать вопрос
) do
  given(:user) { create(:user) }

  describe 'Аутентифицированный пользователь' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'задает вопрос' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'задает вопрос с ошибками' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Не аутентифицированный пользователь пытается задать вопрос' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
# rubocop:enable Style/RedundantPercentQ
