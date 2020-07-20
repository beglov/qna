require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'User can delete answer', %q(
  In order to remove unnecessary answer
  As an answer's author
  I'd like to be able to delete answer
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user, body: 'Bad comment') }
  given(:other_answer) { create(:answer) }

  describe 'Authenticated user tries to delete answer' do
    background { login(user) }

    scenario 'as author of answer', :js do
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Bad comment'
        accept_confirm do
          click_on 'Delete answer'
        end
        expect(page).to_not have_content 'Bad comment'
      end
    end

    scenario 'as not author of answer' do
      visit question_path(other_answer.question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end
# rubocop:enable Style/RedundantPercentQ
