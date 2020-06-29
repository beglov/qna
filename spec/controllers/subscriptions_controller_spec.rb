require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'not subscribed' do
      it 'subscribe to question' do
        expect {
          post :create, params: {question_id: question, format: :js}
        }.to change(user.subscriptions, :count).by(1)
      end
      it 'render create view' do
        post :create, params: {question_id: question, format: :js}
        expect(response).to render_template :create
      end
    end

    context 'already subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'do not subscribe twice' do
        expect {
          post :create, params: {question_id: question, format: :js}
        }.to_not change(user.subscriptions, :count)
      end
      it 'render create view' do
        post :create, params: {question_id: question, format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    before { login(user) }

    it 'unsubscribe to question' do
      expect {
        delete :destroy, params: {id: question, format: :js}
      }.to change(user.subscriptions, :count).from(1).to(0)
    end
    it 'render unsubscribe view' do
      delete :destroy, params: {id: question, format: :js}
      expect(response).to render_template :destroy
    end
  end
end
