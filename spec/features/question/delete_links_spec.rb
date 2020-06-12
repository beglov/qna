require 'rails_helper'

feature 'User can delete links from question', %(
  In order to remove unnecessary links from my question
  As an question's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }
  given!(:link) { create(:link, linkable: question) }
  given!(:other_link) { create(:link, linkable: other_question) }

  scenario "Unauthenticated user can't delete links" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user' do
    background { login(user) }

    scenario "as question's author can delete links", js: true do
      visit question_path(question)

      within "#question-#{question.id}" do
        expect(page).to have_link 'Test link', href: 'http://foo.com'
        accept_confirm do
          click_on 'Delete link'
        end
        expect(page).to_not have_link 'Test link', href: 'http://foo.com'
      end
    end

    scenario "as not question's author can't delete links" do
      visit question_path(other_question)
      expect(page).to_not have_link 'Delete link'
    end
  end
end
