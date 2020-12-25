require 'system_spec_helper'

feature 'User can create question', %q(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
), type: :system do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'asks question with valid fields' do
      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      scenario '' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'and attached files' do
        attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'and assign an award for the best answer' do
        fill_in 'Reward title', with: 'Test reward'
        attach_file 'Reward file', Rails.root.join('spec/fixtures/files/example.jpg')
        click_on 'Ask'

        expect(page).to have_content 'Test reward'
        expect(page).to have_link 'example.jpg'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end

  scenario "question appears on another user's page", :js do
    Capybara.using_session('user') do
      login(user)
      visit questions_path
    end

    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test question'
    end
  end
end
