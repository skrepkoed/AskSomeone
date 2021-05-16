require 'rails_helper'

describe 'Profile Api', type: :request do
  describe 'GET api/v1/profiles/me' do
    let(:headers){ {'ACCEPT'=>'application/json'} }
    it_behaves_like 'API authorizable' do
      let(:method){ :get }
      let(:api_path){ '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me){ create(:user) }
      let(:access_token){ create(:access_token, resource_owner_id:me.id) }
      let(:user_reponse){ json['user'] }
      before { get '/api/v1/profiles/me', params: {access_token: access_token.token}, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end
      
      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_reponse[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return all public fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_reponse).to_not have_key(attr)
        end
      end
    end
  end
end