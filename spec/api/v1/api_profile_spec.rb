require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorazed' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:api_path) { '/api/v1/profiles' }
    let!(:users) { create_list(:user, 3) }
    let!(:user) { users.first }
    let(:user_response) { json['users'].first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'Successful response'

    it 'returns array of users' do
      expect(json['users'].size).to eq 3
    end

    it 'returns all public fields' do
      %w[id email].each do |attr|
        expect(user_response[attr]).to eq user.send(attr).as_json
      end
    end

    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        expect(json).to_not have_key(attr)
      end
    end

    it 'does not contain resource owner' do
      expect(response.body).to_not include_json(me.to_json)
    end
  end
end
