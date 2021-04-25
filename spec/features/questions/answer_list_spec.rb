require 'rails_helper'
feature 'Someone can get list of answers', '
  In order to get the answer to question I`d like to go to question`s show page and
' do
  describe 'if question was answered' do
    given(:question) { create(:question, :with_answer) }
    given(:expected_answers) { question.answers.pluck(:body) }

    background { question.mark_best_answer(question.answers.first.id) }

    scenario 'get list of answers on question`s show page' do
      visit question_path(question)
      expect(page).to have_content 'Best!'
      expected_answers.each { |answer_body| expect(page).to have_content answer_body }
    end
  end

  describe 'if question wasn`t answered' do
    given(:question) { create(:question) }

    scenario 'get message that nobody answered question' do
      visit question_path(question)
      expect(page).to have_content('Nobody has answered this question yet')
    end
  end
end
