require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'User can log out', %q(
  In order to end session
  As an authenticated user
  I'd like to be able to log out
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out' do
    login(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
# rubocop:enable Style/RedundantPercentQ
