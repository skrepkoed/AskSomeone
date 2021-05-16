shared_examples_for 'API authorizable' do
  context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        do_request(method, api_path, headers: headers)
        expect(response.status).to eq 401
      end

      it 'returns 401 status if token is invalid' do
        do_request(method, api_path, params: {access_token: '1234'}, headers: headers)
        expect(response.status).to eq 401
      end
  end

  let!(:me){ create(:user) }
  let(:access_token){ create(:access_token, resource_owner_id:me.id) }
  
  before { do_request(method, api_path, params: {access_token: access_token.token}, headers: headers) }
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end