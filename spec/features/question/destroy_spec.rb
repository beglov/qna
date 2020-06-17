require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'User can delete question', %q(
  In order to remove unnecessary question
  As an question's author
  I'd like to be able to delete question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, title: 'Bad question') }

  describe 'Authenticated user tries to delete question' do
    scenario 'as author of question' do
      login(question.user)
      visit question_path(question)
      expect(page).to have_content 'Bad question'
      click_on 'Delete question'
      expect(page).to_not have_content 'Bad question'

      expect(page).to have_content 'Question was successfully deleted.'
    end

    scenario 'as not author of question' do
      login(user)
      visit question_path(question)
      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end
# rubocop:enable Style/RedundantPercentQ
