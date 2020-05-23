require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ, Metrics/BlockLength
feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:other_question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background { login(user) }

    describe 'edit his answer', js: true do
      background { visit question_path(question) }

      scenario 'with no errors' do
        within "#answer-#{answer.id}" do
          click_on 'Edit'

          fill_in 'Answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with errors' do
        within "#answer-#{answer.id}" do
          click_on 'Edit'
          fill_in 'Answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Answer can't be blank"
        end
      end
    end

    scenario "tries to edit other user's answer" do
      visit question_path(other_question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
# rubocop:enable Style/RedundantPercentQ, Metrics/BlockLength
