require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_question) { create(:question, user: user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: {id: question} }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: {question: attributes_for(:question)}
        }.to change(Question, :count).by(1)
      end
      it 'authenticated user to be author of question' do
        post :create, params: {question: attributes_for(:question)}
        expect(user).to be_author_of(assigns(:question))
      end
      it 'redirects to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: {question: attributes_for(:question, :invalid)}
        }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested question to @question' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}, format: :js}
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}, format: :js}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'render update view' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}, format: :js}
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {id: question, question: attributes_for(:question, :invalid), format: :js} }

      it 'does not change question' do
        question.reload
        expect(question.title).to_not eq nil
        expect(question.body).to eq 'MyText'
      end
      it 'render update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:user_question) { create(:question, user: user) }
    let!(:question) { create(:question) }

    context 'author' do
      it 'delete the question' do
        expect {
          delete :destroy, params: {id: user_question}
        }.to change(Question, :count).by(-1)
      end
      it 'redirects to index' do
        delete :destroy, params: {id: user_question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      it 'no delete the question' do
        expect {
          delete :destroy, params: {id: question}
        }.to_not change(Question, :count)
      end
      it 'redirects to index' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'POST #up' do
    before { login(user) }

    context 'author' do
      it 'not create vote' do
        expect {
          post :up, params: {id: user_question}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create positive vote' do
        expect {
          post :up, params: {id: question}
        }.to change(question.votes.positive, :count).by(1)
      end
    end
  end

  describe 'POST #down' do
    before { login(user) }

    context 'author' do
      it 'not create vote' do
        expect {
          post :down, params: {id: user_question}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create negative vote' do
        expect {
          post :down, params: {id: question}
        }.to change(question.votes.negative, :count).by(1)
      end
    end
  end

  describe 'POST #cancel_vote' do
    before { login(user) }
    before do
      question.votes.create_with(negative: true).find_or_create_by(user_id: user.id)
    end

    it 'delete vote' do
      expect {
        post :cancel_vote, params: {id: question}
      }.to change(question.votes.negative, :count).by(-1)
    end
  end
end
