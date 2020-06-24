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
end
