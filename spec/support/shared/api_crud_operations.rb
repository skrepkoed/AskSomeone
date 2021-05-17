shared_examples_for 'API CRUD operations' do
  
  describe "list of resource" do
    it_behaves_like 'API authorizable'
    context 'Authorized' do
      let(:access_token){ create(:access_token) }
      
      before { do_request(method, api_path, params: {access_token: access_token.token}, headers: headers) }
    
      let(:resource_response){ json[resource_name.pluralize].first }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of question answers' do
        expect(json[resource_name.pluralize].size).to eq resource_collection.count
      end

      it 'returns all public fields' do
        %w[id  body created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq resource.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(resource_response['author']['id']).to eq resource_collection.first.author.id
      end
    end
  end
end