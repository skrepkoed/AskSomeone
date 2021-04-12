require 'rails_helper'

feature 'Unauthenticated user can register in AskSomeone', %(
  In order to ask questions as unauthenticateted user I`d like
  to be able to register
) do
  background { visit new_user_registration_path }
  describe 'User has never been registered before perform' do
    scenario 'registration with valid parameters' do
      fill_in 'Email', with: attributes_for(:user)[:email]
      fill_in 'Password', with: attributes_for(:user)[:password]
      fill_in 'Password confirmation', with: attributes_for(:user)[:password_confirmation]
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
    scenario 'registration with invalid parameters' do
      click_button 'Sign up'

      expect(page).to have_content 'prohibited this user from being saved'
    end
  end
  describe 'User can`t register if' do
    given(:user) { create(:user) }
    scenario 'User has been registered before' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign up'
      expect(page).to have_content 'Email has already been taken'
    end
  end
end
