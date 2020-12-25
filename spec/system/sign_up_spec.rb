require 'system_spec_helper'

feature 'User can register in the system', %q(
  In order to sign in
  As an not registered user
  I'd like to be able to sign up
), type: :system do
  background { visit new_user_registration_path }

  describe 'User tries to sign up' do
    xscenario 'with valid data' do
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

    scenario 'with invalid data' do
      click_button 'Sign up'
      expect(page).to have_content "Email can't be blank"
    end
  end
end
