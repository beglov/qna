require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может зарегистрироваться в системе', %q(
  Чтобы войти в систему
  Не зарегестрированный пользователь
  Должен зарегистрироваться
) do
  background { visit new_user_registration_path }

  describe 'Пользователь регистрируется в системе' do
    scenario 'с корректными данными' do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      clear_emails
      click_button 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

      open_email('new_user@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end

    scenario 'c ошибками' do
      click_button 'Sign up'
      expect(page).to have_content "Email can't be blank"
    end
  end
end
# rubocop:enable Style/RedundantPercentQ
