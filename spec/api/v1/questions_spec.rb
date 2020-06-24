require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
    }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it_behaves_like 'successful status'

      it_behaves_like 'json list' do
        let(:items_responce) { json['questions'] }
        let(:count_items) { 2 }
        let(:public_fields) { %w[id title body created_at updated_at] }
        let(:resource) { question }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(5)
      end

      describe 'answers' do
        it_behaves_like 'json list' do
          let(:items_responce) { question_response['answers'] }
          let(:count_items) { 3 }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource) { answers.first }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: question, created_at: 2.days.ago) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:comment) { create(:comment, commentable: question) }

      before do
        question.files.attach(create_file_blob)
      end

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it_behaves_like 'successful status'

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      describe 'comments' do
        it_behaves_like 'json list' do
          let(:items_responce) { question_response['comments'] }
          let(:count_items) { 3 }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource) { comment }
        end
      end

      describe 'files' do
        let(:file_response) { question_response['files'].first }

        it 'return list of files' do
          expect(question_response['files'].size).to eq 1
        end
      end

      describe 'links' do
        it_behaves_like 'json list' do
          let(:items_responce) { question_response['links'] }
          let(:count_items) { 3 }
          let(:public_fields) { %w[id name url created_at updated_at] }
          let(:resource) { links.last }
        end
      end
    end
  end
end
