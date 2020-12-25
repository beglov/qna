require 'system_spec_helper'

feature 'User can log out', %q(
  In order to end session
  As an authenticated user
  I'd like to be able to log out
), type: :system do
  given(:user) { create(:user) }

  background do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  scenario 'Authenticated user tries to log out' do
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
