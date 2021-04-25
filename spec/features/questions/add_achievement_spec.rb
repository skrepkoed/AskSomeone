require 'rails_helper'

feature 'User can add achievement to his question',
 %q{In order to add achievement to question
  As authenticated user I`d like to be able 
  to ask question and add achievement while asking question} do
  
  given(:user){create(:user)}
  given(:img){"#{Rails.root}/public/apple-touch-icon.png"}

  background do
    sign_in(user)
    visit new_question_path
  end
  
  scenario 'User can add links', js:true do 
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within ('#achievement') do
      fill_in 'Achievement name', with: 'My Achievement'
      attach_file 'Achievement picture', img 
    end

    click_on 'Ask'
    expect(page).to have_content 'My Achievement'
    expect(page).to have_css("img[src*='apple-touch-icon.png']")
  end
end