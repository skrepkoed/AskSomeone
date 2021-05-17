shared_examples_for 'API create' do
  describe 'create resource' do
    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let(:user){ User.find(access_token.resource_owner_id) }
      let(:params){ {:access_token => access_token.token, resource_name.to_sym => attributes_for(resource_name.to_sym)} }
      before { do_request(method, api_path, params: params, headers: headers  ) }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'saves resource' do
        expect{
          do_request(method, api_path, params: params, headers: headers  )
        }.to change(user.send(resource_name.pluralize), :count).by(1)
      end
    end
  end
end