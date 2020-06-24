require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
    }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: {access_token: access_token.token}, headers: headers }

      it_behaves_like 'successful status'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }

      before { get '/api/v1/profiles', params: {access_token: access_token.token}, headers: headers }

      it_behaves_like 'successful status'

      it_behaves_like 'json list' do
        let(:items_responce) { json['users'] }
        let(:count_items) { 2 }
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:resource) { user }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end
