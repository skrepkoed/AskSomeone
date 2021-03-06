require 'rails_helper'

feature 'User can mark answer for question as best',
        "In order to mark answer as best as authenticated user
  and question`s author I'd like to visit question's show page and mark
  question as best", js: true do
  describe 'User is authenticated' do
    given!(:question) { create(:question, :with_answer) }
    given!(:user) { question.author }
    given!(:answer1) { question.answers.first }
    given!(:answer2) { question.answers.last }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can mark question as best' do
      within all('.answer').last do
        click_on('Best answer')
      end

      expect(page).to have_content 'Best!'
      expect(first('.answers')).to have_content answer2.body
    end
  end

  describe 'User isn`t authenticated' do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can`t mark question as best', js: true do
      expect(page).to_not have_content 'Best answer'
    end
  end
end
