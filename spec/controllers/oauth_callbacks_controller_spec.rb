require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe 'Github' do
    let(:oauth_data) { { provider: 'github', uid: 123 } }
    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
      it 'does not login user if it exists' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Google' do
    let(:oauth_data) { { provider: 'google_oauth2', uid: 123 } }
    context 'User has not been authenticated in Asksomeone with google' do
      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :google_oauth2
      end

      it 'renders form for user`s email' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth).with(oauth_data).and_return(nil)
        get :google_oauth2
        expect(response).to render_template :email_confirmation
      end

      it 'redirects to root_path when email confirmed' do
        post :confirm, params: { email: { email: 'someemail1@gmail.com' } },
                       session: { provider: 'google_oauth2', uid: '123', email: 'someemail1@gmail.com' }
        expect(response).to redirect_to root_path
      end

      it 'sign in user' do
        post :confirmed, params: { 'uid' => '123', 'provider' => 'google_oauth2' },
                         session: { provider: 'google_oauth2', uid: '123', email: 'someemail1@gmail.com' }
        expect(subject.current_user).to be_a User
      end
    end
    context 'User has been authenticated in Asksomeone with google' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
