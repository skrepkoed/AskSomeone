require 'rails_helper'

feature 'User can automatically get new answer', 
  %q{In order to get answer immediately as authenticated User
    I`d like to visit question page and if 
    someone answered question than answer appears on page  }, js:true do
  given(:question){ create(:question) }
  given(:user1){ question.author }
  given(:user2){ create(:user) }

  background do
    Capybara.using_session('user1') do
      sign_in(user1)
      visit question_path(question)
    end

    Capybara.using_session('user2') do
      sign_in(user2)
      visit question_path(question)
    end
  end

  scenario 'Answer appears on page when someone answered question' do
    Capybara.using_session('user2') do
      fill_in 'Body', with: 'Answer body'
      click_on 'Answer'
      expect(page).to have_content('Your answer was accepted')
      expect(page).to have_content('Answer body')
      expect(page).to have_content('Delete answer')
      expect(page).to have_content('Edit answer')
    end

    Capybara.using_session('user1') do
      expect(page).to have_content('Answer body')
      expect(page).to have_content('Vote pro')
      expect(page).to have_content('Vote con')
      expect(page).to_not have_content('Delete answer')
      expect(page).to_not have_content('Edit answer')
    end
  end
end