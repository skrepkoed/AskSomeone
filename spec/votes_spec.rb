require 'rails_helper'

feature 'User can vote for answer or question', 
%q{In order to vote for useful answer or question
  as authenticated user I`d like to visit question`s show page
  and vote for question or answer }, js:true do
  describe 'User authenticated' do
    describe 'User can vote for question' do
      given(:question) { create(:question) }
      given(:user) { create(:user) }
      
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User vote for question and counter increments' do
        expect(page).to have_content 'Rating: 0'
        click_on 'Vote pro'
        expect(page).to have_content 'Rating: 1'
      end
    end    
  end
end