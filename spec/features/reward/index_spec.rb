require 'rails_helper'

# rubocop:disable Style/RedundantPercentQ
feature 'User can view their rewards' do
  given(:user) { create(:user) }
  given!(:rewards) { create_list(:reward, 3, user: user) }

  background { login(user) }

  scenario 'User see rewards' do
    visit rewards_path

    expect(page).to have_content 'Rewards list'
    rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
    end
  end
end
# rubocop:enable Style/RedundantPercentQ
