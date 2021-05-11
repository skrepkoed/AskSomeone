require 'rails_helper'

feature 'User can be authenticated with google',
        'As user in order to get access to app with
existing account on google I`d like to visit sign in page and
pass through authenticatation with google ' do
  describe 'User already has been already authenticated with Google' do
    given!(:user) { create(:user) }
    scenario 'User can be authenticated with google and should not confirm email' do
      allow(User).to receive(:find_for_oauth).and_call_original
      allow(User).to receive(:find_for_oauth).and_return(user)
      visit new_user_session_path
      expect(page).to have_content('Sign in with GoogleOauth2')
      mock_auth_google_hash
      click_on 'Sign in with GoogleOauth2'

      expect(page).to have_content('Successfully authenticated from Google account.')
      expect(page).to have_content('Sign out')
    end
  end

  describe 'User has not been authenticated with google' do
    scenario 'User can be authenticated with google' do
      visit new_user_session_path
      expect(page).to have_content('Sign in with GoogleOauth2')
      mock_auth_google_hash
      click_on 'Sign in with GoogleOauth2'
      fill_in 'Email', with: 'somemail1@gmail.com'
      click_on 'Save Email'
      open_email('somemail1@gmail.com')
      current_email.click_link 'Confirm email to Asksomeone'
      expect(page).to have_content('Successfully authenticated from Google account.')
      expect(page).to have_content('Sign out')
    end
  end
end
