require 'rails_helper'

feature 'Authenticated user can answer the question at question`s show page', '
  In order to answer the question as authenticated user
  I`d like to go to question`s show page and if
' do
  describe 'User is authenticated' do
    
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer question with valid parameters' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Answer'

      expect(page).to have_content('Your answer was accepted')
      expect(page).to have_content('Answer body')
    end

    scenario 'answer question with invalid parameters' do
      click_on 'Answer'
      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'User isn`t authenticated' do
    
    given(:question) { create(:question) }

    scenario 'can`t answer question' do
      visit question_path(question)
      expect(page).to have_content('You need to be signed in to answer questions')
    end
  end
end
