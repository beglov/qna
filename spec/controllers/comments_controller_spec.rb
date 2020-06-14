require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect {
          post :create, params: {comment: attributes_for(:comment), id: question, commentable: 'questions', format: :js}
        }.to change(Comment, :count).by(1)
      end
      it 'renders create template' do
        post :create, params: {comment: attributes_for(:comment), id: question, commentable: 'questions', format: :js}
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect {
          post :create, params: {comment: attributes_for(:comment, :invalid), id: question, commentable: 'questions', format: :js}
        }.to_not change(Comment, :count)
      end
      it 'renders create template' do
        post :create, params: {comment: attributes_for(:comment, :invalid), id: question, commentable: 'questions', format: :js}
        expect(response).to render_template :create
      end
    end
  end
end
