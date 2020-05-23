require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ, Metrics/BlockLength
feature 'User can give an answer', %q(
  In order to share my knowledge
  As an authenticated user
  I want to be able to create answers
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'New answer', with: 'Test answer'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'create answer with errors' do
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '#new-answer-errors' do
        expect(page).to have_content "Answer can't be blank"
      end
    end
  end

  scenario 'Not authenticated user tries create answer' do
    visit question_path(question)
    expect(page).to_not have_button 'Reply'
  end
end
# rubocop:enable Style/RedundantPercentQ, Metrics/BlockLength
