require 'system_spec_helper'

feature 'User can show questions list', type: :system do
  given!(:questions) { create_list(:question, 3) }

  scenario 'User viewing questions list' do
    visit questions_path

    expect(page).to have_content 'Questions'
    questions.each { |question| expect(page).to have_content question.title }
  end
end
