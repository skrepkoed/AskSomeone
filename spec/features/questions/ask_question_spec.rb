require 'rails_helper'

feature 'Only authenticated user can ask question', '
  In order to get answer as authenticated user I`d like to go to the
  questions page click on Ask question and if
' do
  describe 'User is authenticated' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'ask a question with valid parameters' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body?'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content "Author: #{user.email}"
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'ask a question with invalid parameters' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
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
