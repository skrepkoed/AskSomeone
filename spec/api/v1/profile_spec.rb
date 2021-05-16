require 'rails_helper'

describe 'Profile Api', type: :request do
  let(:headers){ {'ACCEPT'=>'application/json'} }
  describe 'GET api/v1/profiles/me' do
    it_behaves_like 'API authorizable' do
      let(:method){ :get }
      let(:api_path){ '/api/v1/profiles/me' }
    
      let(:user_reponse){ json['user'] }
        
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

  describe 'GET api/v1/profiles/index' do
    let!(:users){ create_list :user, 2 }
    let(:user_reponse){ json['users'] }  
    it_behaves_like 'API authorizable' do
      let(:method){ :get }
      let(:api_path){ '/api/v1/profiles' }  
      it 'returns all list of users' do
        expect(user_reponse.first).to eq users.first.as_json
        expect(user_reponse.size).to eq users.count
      end

      it 'does not return current user' do
        expect(user_reponse).to_not include(me.as_json)
      end
    end
  end
end