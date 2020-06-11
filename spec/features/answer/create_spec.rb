require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
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

    describe 'create answer with valid fields' do
      background do
        fill_in 'New answer', with: 'Test answer'
      end

      scenario '' do
        click_on 'Reply'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end

      scenario 'and attached files' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], make_visible: true
        click_on 'Reply'

        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
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

  scenario "answer appears on another user's page", js: true do
    Capybara.using_session('user') do
      login(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'New answer', with: 'Test answer'

      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test answer'
    end
  end
end
# rubocop:enable Style/RedundantPercentQ
