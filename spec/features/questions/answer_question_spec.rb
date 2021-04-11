require 'rails_helper'

feature 'Someone can answer the question at question`s show page', %q{
  In order to answer a question I`d like to go to question`s show page and
} do
  given(:question){ create(:question) }
  scenario 'answer question with valid parameters' do
    visit question_path(question)
    fill_in 'Body', with: 'Answer body'
    click_on 'Answer'

    expect(page).to have_content ('Your answer was accepted')
    expect(page).to have_content('Answer body')
  end

  scenario 'answer question with invalid parameters' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content ("Body can't be blank")
  end
end