require 'rails_helper'

feature 'User can vote for the question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_question) { create(:question, user: user) }

  scenario "Unauthenticated user can't vote" do
    visit question_path(question)
    expect(page).to_not have_link 'Up!'
    expect(page).to_not have_link 'Down!'
  end

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'can vote up for the question they like', js: true do
      visit question_path(question)

      within '#question' do
        click_on 'Up!'
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down!'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'can vote down for the question they like', js: true do
      visit question_path(question)

      within '#question' do
        click_on 'Down!'
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down!'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'can cancel their vote', js: true do
      visit question_path(question)

      within '#question' do
        click_on 'Up!'
        expect(page).to_not have_link 'Up!'
        expect(page).to have_content 'Rating: 1'
        click_on 'Cancel vote'
        expect(page).to have_link 'Up!'
        expect(page).to have_content 'Rating: 0'
      end
    end

    scenario 'tries to vote for their question' do
      visit question_path(user_question)

      within '#question' do
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down!'
      end
    end
  end
end
