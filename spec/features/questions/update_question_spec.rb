require 'rails_helper'

feature 'User can update question',
        "In order to change question as authenticated user I'd like
  to visit question`s show page and edit my question" do
  describe 'User is authenticated' do
    describe 'Question belongs to user' do
      given(:question) { create(:question) }
      given(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can edit his own answer', js: true do
        click_on 'Edit question'
        within "#question-#{question.id}" do
          fill_in 'Body', with: 'Edited Question'
          click_on 'Edit'
          expect(page).to_not have_link 'Edit question'
          expect(page).to have_content 'Edited Question'
        end
      end
    end

    describe 'Question doesnt belong to user' do
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can edit his own answer', js: true do
        within "#question-#{question.id}" do
          expect(page).to_not have_link 'Edit question'
        end
      end
    end
  end
end
