require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:user_answer) { create(:answer, user: user, question: question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'GET #show' do
    before { get :show, params: {id: user_answer} }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq user_answer
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
    before { get :edit, params: {id: user_answer} }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq user_answer
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
        patch :update, params: {id: user_answer, answer: {body: 'new body'}, format: :js}
        expect(assigns(:answer)).to eq user_answer
      end
      it 'changes answer attributes' do
        patch :update, params: {id: user_answer, answer: {body: 'new body'}, format: :js}
        user_answer.reload
        expect(user_answer.body).to eq 'new body'
      end
      it 'render update view' do
        patch :update, params: {id: user_answer, answer: {body: 'new body'}, format: :js}
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {id: user_answer, answer: attributes_for(:answer, :invalid), format: :js} }

      it 'does not change answer attributes' do
        user_answer.reload
        expect(user_answer.body).to eq 'MyText'
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
          delete :destroy, params: {id: user_answer, format: :js}
        }.to change(Answer, :count).by(-1)
      end
      it 'render destroy template' do
        delete :destroy, params: {id: user_answer, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      it 'no delete the answer' do
        expect {
          delete :destroy, params: {id: answer, format: :js}
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
      before { post :select_best, params: {id: user_answer, format: :js} }

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq user_answer
      end
      it 'update best attribute' do
        user_answer.reload
        expect(user_answer.best).to eq true
      end
      it 'render select_best template' do
        expect(response).to render_template :select_best
      end
    end

    context 'not author' do
      before { post :select_best, params: {id: answer, format: :js} }

      it 'not update best attribute' do
        user_answer.reload
        expect(user_answer.best).to_not eq true
      end
      it 'render select_best template' do
        expect(response).to render_template :select_best
      end
    end
  end

  describe 'POST #up' do
    before { login(user) }

    context 'author' do
      it 'not create vote' do
        expect {
          post :up, params: {id: user_answer}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create positive vote' do
        expect {
          post :up, params: {id: answer}
        }.to change(answer.votes.positive, :count).by(1)
      end
    end
  end

  describe 'POST #down' do
    before { login(user) }

    context 'author' do
      it 'not create vote' do
        expect {
          post :down, params: {id: user_answer}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create negative vote' do
        expect {
          post :down, params: {id: answer}
        }.to change(answer.votes.negative, :count).by(1)
      end
    end
  end

  describe 'POST #cancel_vote' do
    before { login(user) }
    before do
      answer.votes.create_with(negative: true).find_or_create_by(user_id: user.id)
    end

    it 'delete vote' do
      expect {
        post :cancel_vote, params: {id: answer}
      }.to change(answer.votes.negative, :count).by(-1)
    end
  end
end
