require 'rails_helper'

feature 'Author of question can delete attached files' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario "Unauthenticated user can't delete attached files" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'deletes file of his question', js: true do
      question.files.attach(create_file_blob(filename: 'example.jpg'))
      visit question_path(question)

      within "#question-#{question.id}" do
        expect(page).to have_content 'example.jpg'
        accept_confirm do
          click_on 'Delete file'
        end
        expect(page).to_not have_content 'example.jpg'
      end
    end

    scenario 'tries delete file of other user question' do
      other_question.files.attach(create_file_blob(filename: 'example.jpg'))
      visit question_path(other_question)

      within "#question-#{other_question.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end
