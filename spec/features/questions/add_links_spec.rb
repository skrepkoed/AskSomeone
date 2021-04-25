require 'rails_helper'

feature 'User can add links to his question',
 %q{In order to add links to question
  As authenticated user I`d like to be able 
  to ask question and add link while asking question} do
  
  given(:user){create(:user)}
  given(:url){'https://www.google.com'}

  background do
    sign_in(user)
    visit new_question_path
  end
  
  scenario 'User can add links', js:true do 
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within all('.nested-fields').first do
      fill_in 'Link name', with: 'My url1'
      fill_in 'Url', with: url 
    end

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My url2'
      fill_in 'Url', with: url 
    end

    click_on 'Ask'
    expect(page).to have_link 'My url1', href: url
    expect(page).to have_link 'My url2', href: url
  end
end