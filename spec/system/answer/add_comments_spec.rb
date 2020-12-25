require 'system_spec_helper'

feature 'User can add comments to answer', type: :system do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario "Unauthenticated user can't add comments" do
    visit question_path(question)
    expect(page).to_not have_link 'Add comment'
  end

  describe 'Authenticated user', :js do
    background do
      login(user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_on 'Add comment'
      end
    end

    scenario 'add comment to answer with valid fields' do
      fill_in 'New comment', with: 'New comment'
      click_on 'Save'

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'New comment'
      end
    end

    scenario 'add comment to answer with invalid fields' do
      click_on 'Save'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "comment appears on another user's page", :js do
    Capybara.using_session('user') do
      login(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within "#answer-#{answer.id}" do
        click_on 'Add comment'
      end

      fill_in 'New comment', with: 'New comment'
      click_on 'Save'

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'New comment'
      end
    end

    Capybara.using_session('guest') do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'New comment'
      end
    end
  end
end
