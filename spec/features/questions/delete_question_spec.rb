require 'rails_helper'

feature 'Authenticated user can delete his own questions', '
  In order to delete question as authenticated user I`d like to
  visit question`s show page and if
' do
  describe 'User is authenticated' do
    
    describe 'Question belongs to user' do
      given(:user) { create(:user, :with_question) }

      background do
        sign_in(user)
        visit question_path(user.questions.first)
      end

      scenario 'User can delete his own question' do
        expect(page).to have_content(user.questions.first.body)
        click_on('Delete question')
        expect(page).to have_content('Your question has been deleted')
      end
    end
    
    describe 'Question doesnt belong to user' do
      
      given(:user) { create(:user) }
      given(:question) { create(:question) }
      
      background do
        sign_in(user)
        visit question_path(question.id)
      end

      scenario 'User can`t delete question that belongs to another user' do
        expect(page).to_not have_content('Delete question')
      end
    end
  end

  describe 'User isn`t authenticated' do
    
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'User can`t delete question' do
      visit question_path(question.id)
      expect(page).to_not have_content('Delete question')
    end
  end
end
