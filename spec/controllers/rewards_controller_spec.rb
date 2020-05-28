require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let!(:user_rewards) { create_list(:reward, 3, user: user) }
  let!(:other_rewards) { create_list(:reward, 3) }

  describe "GET #index" do
    before { login(user) }
    before { get :index }

    it 'populates an array of user rewards' do
      expect(assigns(:rewards)).to match_array(user_rewards)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end
end
