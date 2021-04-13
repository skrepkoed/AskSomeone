require 'rails_helper'

feature 'Someone can sign in and become registered user', '
  In order to ask questions as unauthenticateted user I`d like
  to be able to sign in
' do
  
  given(:user) { create(:user) }
  
  background { visit new_user_session_path }
  
  scenario 'Registered user can sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user can`t sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
