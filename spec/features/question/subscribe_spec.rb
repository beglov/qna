require 'rails_helper'

feature 'User can subscribe to question' do
  given(:question) { create(:question) }

  scenario 'Unauthenticated user tries subscribe to question' do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    scenario 'subscribe to question' do
      login(user)

      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end
end
