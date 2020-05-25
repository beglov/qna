require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    background { login(user) }

    describe 'edit his question', js: true do
      background do
        visit question_path(question)
        click_on 'Edit question'
      end

      describe 'with valid fields' do
        background do
          fill_in 'Title', with: 'New Title'
          fill_in 'Body', with: 'New Body'
        end

        scenario '' do
          within '#question' do
            click_on 'Update'

            expect(page).to_not have_content question.title
            expect(page).to_not have_content question.body
            expect(page).to have_content 'New Title'
            expect(page).to have_content 'New Body'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'and attached files' do
          within '#question' do
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Update'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end
      end

      scenario 'with errors' do
        within '#question' do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Update'

          expect(page).to have_content question.title
          expect(page).to have_content question.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Title can't be blank"
        end
      end
    end

    scenario "tries to edit other user's question" do
      visit question_path(other_question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end
# rubocop:enable Style/RedundantPercentQ
