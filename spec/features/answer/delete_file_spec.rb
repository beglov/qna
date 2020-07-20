require 'rails_helper'

feature 'Author of answer can delete attached files' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:other_user_answer) { create(:answer, question: question) }

  scenario "Unauthenticated user can't delete attached files" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated user' do
    background { login(user) }
    background do
      answer.files.attach(create_file_blob(filename: 'example.jpg'))
      other_user_answer.files.attach(create_file_blob(filename: 'example.jpg'))

      visit question_path(question)
    end

    scenario 'deletes file of his answer', :js do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'example.jpg'
        accept_confirm do
          click_on 'Delete file'
        end
        expect(page).to_not have_content 'example.jpg'
      end
    end

    scenario 'tries delete file of other user answer' do
      within "#answer-#{other_user_answer.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end
