require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'Пользователь может выйти из системы', %q(
  Чтобы завершить сессию
  Аутентифицированный пользователь
  Должен выйти из системы
) do
  given(:user) { create(:user) }

  scenario 'Аутентифицированный пользователь выходит из системы' do
    login(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
# rubocop:enable Style/RedundantPercentQ
