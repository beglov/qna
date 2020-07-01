require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'calls ThinkingSphinx.search' do
      expect(ThinkingSphinx).to receive(:search).with('')
      get :index, params: {q: '', context: 'All'}
    end

    it 'calls Question.search' do
      expect(Question).to receive(:search).with('')
      get :index, params: {q: '', context: 'Question'}
    end

    it 'calls Answer.search' do
      expect(Answer).to receive(:search).with('')
      get :index, params: {q: '', context: 'Answer'}
    end

    it 'calls Comment.search' do
      expect(Comment).to receive(:search).with('')
      get :index, params: {q: '', context: 'Comment'}
    end

    it 'calls User.search' do
      expect(User).to receive(:search).with('')
      get :index, params: {q: '', context: 'User'}
    end

    it 'renders template index' do
      allow(ThinkingSphinx).to receive(:search).with('')
      get :index, params: {q: '', context: 'All'}
      expect(response).to render_template :index
    end
  end
end
