require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:service) { double('Services::Search') }

    it 'calls Services::Search#call' do
      expect(Services::Search).to receive(:new).with('All', '').and_return(service)
      expect(service).to receive(:call)
      get :index, params: {q: '', context: 'All'}
    end

    it 'renders template index' do
      allow(Services::Search).to receive(:new).and_return(service)
      allow(service).to receive(:call)
      get :index, params: {q: '', context: 'All'}
      expect(response).to render_template :index
    end
  end
end
