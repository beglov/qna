require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:other_answer) { create(:answer, question: question) }

  describe 'GET #show' do
    before { get :show, params: {id: answer} }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: {question_id: question} }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: {id: answer} }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    let!(:answer) { create(:answer) }

    it 'assigns question to @question' do
      post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        }.to change(question.answers, :count).by(1)
      end
      it 'authenticated user to be author of answer' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(user).to be_author_of(assigns(:answer))
      end
      it 'renders create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js}
        }.to_not change(Answer, :count)
      end
      it 'renders create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: {id: answer, answer: {body: 'new body'}, format: :js}
        expect(assigns(:answer)).to eq answer
      end
      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}, format: :js}
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'render update view' do
        patch :update, params: {id: answer, answer: {body: 'new body'}, format: :js}
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid), format: :js} }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end
      it 'render update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author' do
      it 'delete the answer' do
        expect {
          delete :destroy, params: {id: answer, format: :js}
        }.to change(Answer, :count).by(-1)
      end
      it 'render destroy template' do
        delete :destroy, params: {id: answer, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      it 'no delete the answer' do
        expect {
          delete :destroy, params: {id: other_answer, format: :js}
        }.to_not change(Answer, :count)
      end
      it 'render destroy template' do
        delete :destroy, params: {id: answer, format: :js}
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'POST #select_best' do
    before { login(user) }

    context 'author' do
      before { post :select_best, params: {id: answer, format: :js} }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
      it 'update best attribute' do
        answer.reload
        expect(answer.best).to eq true
      end
      it 'render select_best template' do
        expect(response).to render_template :select_best
      end
    end

    context 'not author' do
      before { post :select_best, params: {id: other_answer, format: :js} }

      it 'not update best attribute' do
        answer.reload
        expect(answer.best).to_not eq true
      end
      it 'render select_best template' do
        expect(response).to render_template :select_best
      end
    end
  end

  describe 'POST #up' do
    before { login(user) }

    it 'create positive vote' do
      expect {
        post :up, params: {id: other_answer}
      }.to change(other_answer.votes.positive, :count).by(1)
    end
  end

  describe 'POST #down' do
    before { login(user) }

    it 'create negative vote' do
      expect {
        post :down, params: {id: other_answer}
      }.to change(other_answer.votes.negative, :count).by(1)
    end
  end
end
