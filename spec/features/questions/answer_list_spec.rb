require 'rails_helper'
feature 'Someone can get list of answers', %q{
  In order to get the answer to question I`d like to go to question`s show page and
}do
  describe 'if question was answered' do 
    given(:question){create(:question,:with_answer)}
    scenario 'get list of answers on question`s show page' do
      visit question_path(question)
      expect(page.all('li.answer').size).to eq question.answers.size
    end
  end

  describe 'if question wasn`t answered' do
    given(:question){create(:question)}
    scenario 'get message that nobody answered question' do
      visit question_path(question)
      expect(page).to have_content('Nobody has answered this question yet')
    end
  end
end