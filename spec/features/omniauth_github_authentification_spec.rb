require 'rails_helper'

feature 'User can be authenticated with github',
        'As user in order to get access to app with
existing account on github I`d like to visit sign in page and
pass through authenticatation with github ' do
  describe 'User already has account in Asksomeone' do
    given!(:user) { create(:user) }
    scenario 'User can be authenticated with github' do
      visit new_user_session_path
      expect(page).to have_content('Sign in with GitHub')
      mock_auth_github_hash(user)
      click_on 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from Github account.')
      expect(page).to have_content('Sign out')
    end
  end

  describe 'User failed authenticatation' do
    given!(:user) { create(:user) }

    scenario 'User can not be auth with GitHub' do
      visit new_user_session_path
      authentication_failure(:github)
      click_on 'Sign in with GitHub'
      expect(page).to have_content('Could not authenticate you from GitHub because "Invalid credentials"')
      expect(page).to have_content('Sign in')
    end
  end

  describe 'User has not account in Asksomeone' do
    given(:user) { double 'UserWithAccountOnGithub' }
    scenario 'User can be authenticated with github' do
      allow(user).to receive(:email).and_return('somemail1@gmail.com')
      visit new_user_session_path
      expect(page).to have_content('Sign in with GitHub')
      mock_auth_github_hash(user)
      click_on 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from Github account.')
      expect(page).to have_content('Sign out')
    end
  end
end
