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
        let(:resource) { questions.first }
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

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:comments) { create_list(:comment, 1, commentable: question) }
      let!(:links) { create_list(:link, 1, linkable: question) }
      let(:question_response) { json['question'] }

      before do
        question.files.attach(create_file_blob)

        get api_path, params: {access_token: access_token.token}, headers: headers
      end

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
          let(:count_items) { 1 }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource) { comments.first }
        end
      end

      describe 'files' do
        it 'return list of files' do
          expect(question_response['files'].size).to eq 1
        end
      end

      describe 'links' do
        it_behaves_like 'json list' do
          let(:items_responce) { question_response['links'] }
          let(:count_items) { 1 }
          let(:public_fields) { %w[id name url created_at updated_at] }
          let(:resource) { links.first }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'valid parameters' do
        let(:question_params) do
          {
            'title' => 'Question title',
            'body' => 'Question body',
          }
        end

        it 'creates a new question' do
          expect {
            post api_path, params: {access_token: access_token.token, question: question_params}.to_json, headers: headers
          }.to change { user.questions.count }.from(0).to(1)
        end

        it 'returns an question' do
          post api_path, params: {access_token: access_token.token, question: question_params}.to_json, headers: headers
          expect(response).to have_http_status(:created)
          expect(json['question']).to a_hash_including(question_params)
        end
      end

      context 'invalid parameters' do
        let(:question_params) { {'title' => 'Question title'} }

        it "does't creates a new question" do
          expect {
            post api_path, params: {access_token: access_token.token, question: question_params}.to_json, headers: headers
          }.to_not change { user.questions.count }
        end

        it 'returns an error' do
          post api_path, params: {access_token: access_token.token, question: question_params}.to_json, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }
      let(:question_params) do
        {
          'title' => 'New title',
          'body' => 'New body',
        }
      end

      context 'author' do
        let(:question) { create(:question, user: user) }

        it 'updates the question' do
          put api_path, params: {access_token: access_token.token, question: question_params}.to_json, headers: headers
          expect(response).to have_http_status(:ok)
          expect(json['question']).to a_hash_including(question_params)
        end
      end

      context 'not author' do
        let(:question) { create(:question) }

        it 'returns an error' do
          put api_path, params: {access_token: access_token.token, question: question_params}.to_json, headers: headers
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'author' do
        let!(:question) { create(:question, user: user) }

        it 'delete the question' do
          expect {
            delete api_path, params: {access_token: access_token.token}.to_json, headers: headers
          }.to change { user.questions.count }.from(1).to(0)

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'not author' do
        let!(:question) { create(:question) }

        it "does't delete the question" do
          expect {
            delete api_path, params: {access_token: access_token.token}.to_json, headers: headers
          }.to_not change { user.questions.count }
        end

        it 'returns an error' do
          delete api_path, params: {access_token: access_token.token}.to_json, headers: headers
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end
end
