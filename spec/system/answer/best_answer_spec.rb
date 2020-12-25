require 'system_spec_helper'

feature 'User can select best answer', %q(
  In order to show best answer for me
  As an author of question
  I'd like to be able to select best answer
), type: :system do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, user: user, question: question) }

  scenario "Unauthenticated user can't select best answer" do
    visit question_path(question)
    expect(page).to_not have_link 'Select best!'
  end

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'select best answer for his question', :js do
      visit question_path(question)

      answers.each do |answer|
        within "#answer-#{answer.id}" do
          click_on 'Select best!'
          expect(page).to have_content 'This is best answer!'
          expect(page).to_not have_link 'Select best!'
        end
      end

      expect(page.all('.best-answer-title').size).to eq 1
    end

    scenario 'tries select best answer for another question' do
      visit question_path(other_question)
      expect(page).to_not have_link 'Select best!'
    end
  end
end
