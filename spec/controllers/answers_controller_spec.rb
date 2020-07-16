require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

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

    let(:form_params) { attributes_for(:answer) }
    let(:params) do
      {
        question_id: question,
        answer: form_params,
        format: :js
      }
    end

    subject { post :create, params: params }

    it 'assigns question to @question' do
      subject
      expect(assigns(:question)).to eq question
    end

    it 'saves a new answer in the database' do
      expect { subject }.to change(question.answers, :count).by(1)
    end
    it 'authenticated user to be author of answer' do
      subject
      expect(user).to be_author_of(assigns(:answer))
    end
    it 'renders create template' do
      subject
      expect(response).to render_template :create
    end

    context 'with invalid attributes' do
      let(:form_params) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { subject }.to_not change(Answer, :count)
      end
      it 'renders create template' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let(:form_params) { {body: 'new body'} }
    let(:params) do
      {
        id: answer,
        answer: form_params,
        format: :js
      }
    end

    subject { patch :update, params: params }

    it 'assigns requested answer to @answer' do
      subject
      expect(assigns(:answer)).to eq answer
    end
    it 'changes answer attributes' do
      subject
      answer.reload
      expect(answer.body).to eq 'new body'
    end
    it 'render update view' do
      subject
      expect(response).to render_template :update
    end

    context 'with invalid attributes' do
      let(:form_params) { {body: ''} }

      before { subject }

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
    subject { delete :destroy, params: {id: answer, format: :js} }

    before { login(user) }

    context 'author' do
      it 'delete the answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end
      it 'render destroy template' do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      let!(:answer) { create(:answer, question: question) }

      it 'no delete the answer' do
        expect { subject }.to_not change(Answer, :count)
      end
      it 'return forbidden status' do
        subject
        expect(response).to have_http_status(:forbidden)
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
      let!(:answer) { create(:answer, question: question) }

      before { post :select_best, params: {id: answer, format: :js} }

      it 'not update best attribute' do
        answer.reload
        expect(answer.best).to_not eq true
      end
      it 'return forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  it_behaves_like 'voted' do
    let(:votable) { create(:answer) }
    let(:user_votable) { create(:answer, user: user) }
  end
end
