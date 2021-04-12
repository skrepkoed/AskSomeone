require 'rails_helper'

feature 'Someone can get list of all questions', '
  In order to find question I`d like to
' do
  background { create_list(:question, 3) }
  scenario 'get list of questions' do
    visit questions_path
    expect(page).to have_content 'Questions'
    expect(page.all('li', text: 'MyTitle').size).to eq Question.count
  end
end
