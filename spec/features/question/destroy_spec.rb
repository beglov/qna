require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Автор может удалить свой вопрос, но не может удалить чужой вопрос', %q(
  Чтобы избавиться от ненужного вопроса
  Автор вопроса
  Может может удалить вопрос
) do
  given(:user) { create(:user) }
  given(:question) { user.questions.create(attributes_for(:question)) }
  given(:other_question) { create(:question) }

  describe 'Аутентифицированный пользователь пытается удалить вопрос' do
    background { login(user) }

    scenario 'являясь автором вопроса' do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question was successfully deleted.'
    end

    scenario 'не являясь автором вопроса' do
      visit question_path(other_question)
      click_on 'Delete'

      expect(page).to have_content 'Delete unavailable! You are not the author of the question.'
    end
  end

  scenario 'Не аутентифицированный пользователь пытается удалить вопрос' do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
# rubocop:enable Style/RedundantPercentQ
