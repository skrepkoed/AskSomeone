require 'rails_helper'

feature 'Someone can ask question', '
  In order to get answer I`d like to
' do
    scenario 'ask a question' do
      visit new_question_path
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body?'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
  end
end

feature 'Someone can get list of all questions', %q{
  In order to find question I`d like to 
}do
  background{ create_list(:question, 3) }
  scenario 'get list of questions' do
    visit questions_path
    expect(page).to have_content 'Questions'
    expect(page.all('li', text:'MyTitle').size).to eq Question.count
  end
end