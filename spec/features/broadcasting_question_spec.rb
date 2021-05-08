require 'rails_helper'

feature 'User can automatically get new question',
        'In order to get question immediately as  User
    I`d like to visit question`s index page and if
    someone asked question than question appears on page  ', js: true do
  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Question appears on page when someone asked question', js: true do
    Capybara.using_session('user1') do
      sign_in(user1)
      visit questions_path
      click_on 'Ask question'
    end

    Capybara.using_session('user2') do
      sign_in(user2)
      visit questions_path
    end

    Capybara.using_session('user1') do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body?'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content "Author: #{user1.email}"
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    Capybara.using_session('user2') do
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end
  end
end
