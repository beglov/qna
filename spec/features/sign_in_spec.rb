require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
) do
  given(:user) { create(:user) }
  given(:unconfirmed_user) { create(:user, confirmed_at: nil) }
  background { visit new_user_session_path }

  describe 'Registered user tries to sign in' do
    scenario 'with confirmed email' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'with unconfirmed email' do
      fill_in 'Email', with: unconfirmed_user.email
      fill_in 'Password', with: unconfirmed_user.password
      click_on 'Log in'

      expect(page).to have_content 'You have to confirm your email address before continuing.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User can sign in with Github account' do
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User can handle authentication error' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Invalid credentials'
  end

  scenario 'User can sign in with Vkontakte account' do
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
  end

  scenario 'User can handle authentication error' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Invalid credentials'
  end
end
