require 'system_spec_helper'

feature 'User can add links to answer', %(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
), type: :system do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/beglov/4d3e2213d48d6741b7215cff8bfa1bfd' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links when give an answer', :js do
    login(user)
    visit question_path(question)

    fill_in 'New answer', with: 'Test answer'

    click_on 'add link'
    within '.nested-fields:last-of-type' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end
    click_on 'add link'
    within '.nested-fields:last-of-type' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_content 'Hello world!'
      expect(page).to have_link 'Google', href: google_url
    end
  end
end
