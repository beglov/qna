require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может войти в систему', %q(
  Чтобы задать вопрос
  Зарегестрированный пользователь
  Должен войти в систему
) do
  given(:user) { create(:user) }
  given(:unconfirmed_user) { create(:user, confirmed_at: nil) }
  background { visit new_user_session_path }

  scenario 'Зарегистрированный пользователь пытается войти в систему с подтвержденной почтой' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Зарегистрированный пользователь пытается войти в систему с НЕ подтвержденной почтой' do
    fill_in 'Email', with: unconfirmed_user.email
    fill_in 'Password', with: unconfirmed_user.password
    click_on 'Log in'

    expect(page).to have_content 'You have to confirm your email address before continuing.'
  end

  scenario 'Не зарегистрированный пользователь пытается войти в систему' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario "can sign in user with Github account" do
    click_on "Sign in with GitHub"
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on "Sign in with GitHub"
    expect(page).to have_content 'Invalid credentials'
  end
end
# rubocop:enable Style/RedundantPercentQ
