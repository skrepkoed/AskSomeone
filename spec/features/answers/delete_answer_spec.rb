require 'rails_helper'

feature 'Authenticated user can delete his own answers', '
  In order to delete answer as authenticated user I`d like to
  visit question`s show page and if
' do
  describe 'User is authenticated' do
    describe 'Answer belongs to user' do
      given(:answer) { create(:answer) }
      given(:user) { answer.author }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question.id)
      end

      scenario 'User can delete his own answer', js: true do
        expect(page).to have_content(answer.body)
        click_on('Delete answer')
        expect(page).to have_content('Your answer has been deleted')
        expect(page).to_not have_content(answer.body)
      end
    end

    describe 'Answer doesn`t belong to user' do
      given(:user) { create(:user) }
      given(:answer) { create(:answer) }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question.id)
      end

      scenario 'User can`t delete answer that belongs to another user', js: true do
        expect(page).to_not have_content('Delete answer')
      end
    end
  end

  describe 'User isn`t authenticated' do
    given(:user) { create(:user) }
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    scenario 'User can`t delete question', js: true do
      visit question_path(question.id)
      expect(page).to_not have_content('Delete question')
    end
  end
end
