require 'rails_helper'

feature 'User can add links to his answer',
        'In order to add links to answer
  As authenticated user I`d like to be able
  to ask answer and add link while asking answer' do
  given(:question) { create(:question) }
  given(:user) { question.author }
  given(:url) { 'https://www.google.com' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User can add links', js: true do
    fill_in 'Body', with: 'text text text'

    within all('#new-answer-links .nested-fields').first do
      fill_in 'Link name', with: 'My url1'
      fill_in 'Url', with: url
    end

    click_on 'Add link'

    within all('#new-answer-links .nested-fields').last do
      fill_in 'Link name', with: 'My url2'
      fill_in 'Url', with: url
    end

    click_on 'Answer'

    expect(page).to have_link 'My url1', href: url
    expect(page).to have_link 'My url2', href: url
  end
end
