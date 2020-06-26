require 'rails_helper'

feature 'User can unsubscribe to question' do
  given(:question) { create(:question) }

  scenario 'Unauthenticated user tries unsubscribe to question' do
    visit question_path(question)
    expect(page).to_not have_link 'Unsubscribe'
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:subscription) { create(:subscription, user: user, question: question) }

    scenario 'unsubscribe to question' do
      login(user)

      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end
end
