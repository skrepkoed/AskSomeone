shared_examples_for 'API destroy' do
  it_behaves_like 'API authorizable'
  describe 'destroy resource' do
    context 'authorized' do
      it 'destroys resource' do
        expect do
          do_request(method, api_path,
                     params: { access_token: access_token.token }, headers: headers)
        end.to change(
          user.send(resource_name.pluralize), :count
        ).by(-1)
        expect(response).to be_successful
      end
    end

    context 'resource does not belong to user' do
      it 'does not destroy resource' do
        expect do
          do_request(method, api_path_for_unauthorized_action,
                     params: { access_token: access_token.token }, headers: headers)
        end.to_not change(
          resource_name.capitalize.constantize, :count
        )
        expect(response.status).to eq 401
      end
    end
  end
end
