require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:other_question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background { login(user) }

    describe 'edit his answer', js: true do
      given(:google_url) { 'https://www.google.com/' }
      given(:gist_url) { 'https://gist.github.com/beglov/736817e4f485da27bf995a6bda7fb7a9' }

      background do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_on 'Edit'
        end
      end

      describe 'with valid fields' do
        background do
          within "#answer-#{answer.id}" do
            fill_in 'answer[body]', with: 'edited answer'
          end
        end

        scenario '' do
          within "#answer-#{answer.id}" do
            click_on 'Save'

            expect(page).to_not have_content answer.body
            expect(page).to have_content 'edited answer'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'and attached files' do
          within "#answer-#{answer.id}" do
            attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], make_visible: true
            click_on 'Save'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end

        scenario 'can adds links' do
          within "#answer-#{answer.id}" do
            click_on 'add link'
            within '.nested-fields:last-of-type' do
              fill_in 'Link name', with: 'Google'
              fill_in 'Url', with: google_url
            end
            click_on 'add link'
            within '.nested-fields:last-of-type' do
              fill_in 'Link name', with: 'My gist'
              fill_in 'Url', with: gist_url
            end

            click_on 'Save'

            expect(page).to have_link 'Google', href: google_url
            expect(page).to have_content 'Hello world!'
          end
        end
      end

      scenario 'with errors' do
        within "#answer-#{answer.id}" do
          fill_in 'answer[body]', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Answer can't be blank"
        end
      end
    end

    scenario "tries to edit other user's answer" do
      visit question_path(other_question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
# rubocop:enable Style/RedundantPercentQ
