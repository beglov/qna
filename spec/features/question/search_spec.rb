require 'sphinx_helper'

feature 'User can search for question', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
" do
  given!(:question) { create(:question, title: '123') }

  background { visit questions_path }

  scenario 'User searches for the existing question', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search for', with: '123'

      click_on 'Search'

      within ".questions" do
        expect(page).to have_content '123'
      end
    end
  end

  scenario 'User searches for the not existing question', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search for', with: 'nothing'

      click_on 'Search'

      within ".questions" do
        expect(page).to_not have_content 'nothing'
      end
    end
  end
end
