require 'rails_helper'
feature 'Someone can ask question', '
  In order to get answer I`d like to
' do
  given(:user) { create(:user) }

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
