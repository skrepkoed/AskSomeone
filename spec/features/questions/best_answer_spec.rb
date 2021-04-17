require 'rails_helper'

feature 'User can mark answer for question as best',
        "In order to mark answer as best as authenticated user
  and question`s author I'd like to visit question's show page and mark
  question as best" do
  
  describe 'User is authenticated' do
    
    given(:answer) { create(:answer) }
    given(:user) { answer.author }
    given(:question) { answer.question }
    given(:another_answer) { create(:answer, :for_create, question_id: question.id, user_id: user.id) }

    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'User can mark question as best', js: true do
      within '.answers' do
        page.all(class: 'answer').last.click_link('Best answer')
      end
      expect(page).to have_content 'Best!'
      expect(first('.answers')).to have_content another_answer.body
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

    scenario 'User can`t mark question as best' do
      expect(page).to_not have_content 'Best answer'
    end
  end
end
