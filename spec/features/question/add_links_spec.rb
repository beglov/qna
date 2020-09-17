require 'rails_helper'

feature 'User can add links to question', %(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/beglov/4d3e2213d48d6741b7215cff8bfa1bfd' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links to when asks question', :js do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

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

    click_on 'Ask'

    expect(page).to have_content 'Hello world!'
    expect(page).to have_link 'Google', href: google_url
  end
end
