# require 'sphinx_helper'

xfeature 'User can search for question', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
", type: :system do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer) }

  background { visit root_path }

  scenario 'in all context', :js, :sphinx do
    select 'All', from: 'context'
    click_on 'Search'
    expect(page).to have_content user.email
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body

    fill_in 'Search', with: question.title
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
  end

  scenario 'in questions context', :js, :sphinx do
    select 'Question', from: 'context'
    fill_in 'Search', with: question.title
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
  end

  scenario 'in answers context', :js, :sphinx do
    select 'Answer', from: 'context'
    fill_in 'Search', with: answer.body
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to have_content answer.body
    expect(page).to_not have_content comment.body
  end

  scenario 'in comments context', :js, :sphinx do
    select 'Comment', from: 'context'
    fill_in 'Search', with: comment.body
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to have_content comment.body
  end

  scenario 'in users context', :js, :sphinx do
    select 'User', from: 'context'
    fill_in 'Search', with: user.email
    click_on 'Search'
    expect(page).to have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
  end
end
