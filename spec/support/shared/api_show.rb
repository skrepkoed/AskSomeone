shared_examples_for 'API show' do  
  describe 'show resource' do
    it_behaves_like 'API authorizable'
    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let(:resource_response){ json[resource_name] }
      before { do_request(method, api_path, params: {access_token: access_token.token}, headers: headers) }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id  body author created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq resource.send(attr).as_json
        end
        
        expect(resource_response['links_url'].first).to eq resource.links.first.url
        expect(resource_response['comments'].first['body']).to eq resource.comments.first.body.as_json
        expect(resource_response['files_url'].first).to eq Rails.application.routes.url_helpers.rails_blob_path(resource.files.first, only_path: true) 
      end
    end
  end
end