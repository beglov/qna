require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может просматривать список вопросов', %q(
  Чтобы найти интересующие его вопросы
  Любой пользователь
  Может просмотреть список всех вопросов
) do
  given!(:questions) { create_list(:question, 3) }

  scenario 'Пользователь просматривает список вопросов' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end
end
# rubocop:enable Style/RedundantPercentQ
