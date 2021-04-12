require 'rails_helper'

feature 'Only authenticated user can ask question', '
  In order to get answer as authenticated user I`d like to go to the 
  questions page click on Ask question and if
' do
  describe 'User is authenticated' do 
    given(:user){ create(:user) }
    background{ sign_in(user) }
      scenario 'ask a question' do
        visit questions_path
        click_on 'Ask question'
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Question body?'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content "Author: #{user.email}"
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
    end
  end

  describe 'User isn`t authenticated' do
    scenario 'can`t ask question' do
      visit questions_path
      click_on 'Ask question'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end