require 'rails_helper'

feature 'User can delete links from answer', %(
  In order to remove unnecessary links from my answer
  As an answer's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:other_answer) { create(:answer, question: question) }
  given!(:link) { create(:link, linkable: answer) }
  given!(:other_link) { create(:link, linkable: other_answer) }

  scenario "Unauthenticated user can't delete links" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user' do
    background { login(user) }
    background { visit question_path(question) }

    scenario "as answer's author can delete links", :js do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Test link', href: 'http://foo.com'
        accept_confirm do
          click_on 'Delete link'
        end
        expect(page).to_not have_link 'Test link', href: 'http://foo.com'
      end
    end

    scenario "as not answer's author can't delete links" do
      within "#answer-#{other_answer.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end
end
