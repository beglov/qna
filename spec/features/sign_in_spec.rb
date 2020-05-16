require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может войти в систему', %q(
  Чтобы задать вопрос
  Зарегестрированный пользователь
  Должен войти в систему
) do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Зарегистрированный пользователь пытается войти в систему' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    # save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Не зарегистрированный пользователь пытается войти в систему' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
# rubocop:enable Style/RedundantPercentQ
