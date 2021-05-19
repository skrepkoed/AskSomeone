shared_examples_for 'API update' do
  describe 'update resource' do
    it_behaves_like 'API authorizable'
    context 'authorized' do
      let(:resource_response) { json[resource_name] }
      let(:params) { { :access_token => access_token.token, resource_name.to_sym => { body: 'new_body' } } }
      before { do_request(method, api_path, params: params, headers: headers) }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'updates resource' do
        expect(resource_response['body']).to eq 'new_body'
      end

      context 'invalid attribute' do
        let(:params) { { :access_token => access_token.token, resource_name.to_sym => { body: '' } } }
        before { do_request(method, api_path, params: params, headers: headers) }
        it 'returns 401 status' do
          expect(response.status).to eq 401
        end
      end

      context 'resource does not belong to user' do
        let(:params) { { :access_token => access_token.token, resource_name.to_sym => { body: 'new_body' } } }
        before { do_request(method, api_path_for_unauthorized_action, params: params, headers: headers) }
        it 'does not update question' do
          expect(response.status).to eq 401
        end
      end
    end
  end
end
