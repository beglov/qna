require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
    }
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it_behaves_like 'successful status'

      it_behaves_like 'json list' do
        let(:items_responce) { json['answers'] }
        let(:count_items) { 3 }
        let(:public_fields) { %w[id user_id body best created_at updated_at] }
        let(:resource) { answers.first }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:comments) { create_list(:comment, 1, commentable: answer) }
      let!(:links) { create_list(:link, 1, linkable: answer) }
      let(:answer_response) { json['answer'] }

      before do
        answer.files.attach(create_file_blob)

        get api_path, params: {access_token: access_token.token}, headers: headers
      end

      it_behaves_like 'successful status'

      it 'returns all public fields' do
        %w[id user_id body best created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        it_behaves_like 'json list' do
          let(:items_responce) { answer_response['comments'] }
          let(:count_items) { 1 }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
          let(:resource) { comments.first }
        end
      end

      describe 'files' do
        it 'return list of files' do
          expect(answer_response['files'].size).to eq 1
        end
      end

      describe 'links' do
        it_behaves_like 'json list' do
          let(:items_responce) { answer_response['links'] }
          let(:count_items) { 1 }
          let(:public_fields) { %w[id name url created_at updated_at] }
          let(:resource) { links.first }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'valid parameters' do
        let(:answer_params) do
          {
            'body' => 'Answer body',
          }
        end

        it 'creates a new answer' do
          expect {
            post api_path, params: {access_token: access_token.token, answer: answer_params}.to_json, headers: headers
          }.to change { user.answers.count }.from(0).to(1)
        end

        it 'returns an answer' do
          post api_path, params: {access_token: access_token.token, answer: answer_params}.to_json, headers: headers
          expect(response).to have_http_status(:created)
          expect(json['answer']).to a_hash_including(answer_params)
        end
      end

      context 'invalid parameters' do
        let(:answer_params) { {'body' => ''} }

        it "does't creates a new answer" do
          expect {
            post api_path, params: {access_token: access_token.token, answer: answer_params}.to_json, headers: headers
          }.to_not change { user.answers.count }
        end

        it 'returns an error' do
          post api_path, params: {access_token: access_token.token, answer: answer_params}.to_json, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }
      let(:answer_params) do
        {
          'body' => 'New body',
        }
      end

      context 'author' do
        let(:answer) { create(:answer, user: user) }

        it 'updates the answer' do
          put api_path, params: {access_token: access_token.token, answer: answer_params}.to_json, headers: headers
          expect(response).to have_http_status(:ok)
          expect(json['answer']).to a_hash_including(answer_params)
        end
      end

      context 'not author' do
        let(:answer) { create(:answer) }

        it 'returns an error' do
          put api_path, params: {access_token: access_token.token, answer: answer_params}.to_json, headers: headers
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'author' do
        let!(:answer) { create(:answer, user: user) }

        it 'delete the answer' do
          expect {
            delete api_path, params: {access_token: access_token.token}.to_json, headers: headers
          }.to change { user.answers.count }.from(1).to(0)

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'not author' do
        let!(:answer) { create(:answer) }

        it "does't delete the answer" do
          expect {
            delete api_path, params: {access_token: access_token.token}.to_json, headers: headers
          }.to_not change { user.answers.count }
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
