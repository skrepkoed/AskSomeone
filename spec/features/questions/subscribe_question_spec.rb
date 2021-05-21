require 'rails_helper'

feature 'In order to receive notifications about queestion As authenticated user
I`d like to visit queestion`s page and subscribe to question  ' do
  describe 'User is authenticated' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can subscribe to question', js: true do
      expect(page).to have_content('Subscribe')
      click_on('Subscribe')
      expect(page).to have_content('Unsubscribe')
    end

    scenario 'User can unsubscribe to question', js: true do
      click_on('Subscribe')
      click_on('Unsubscribe')
      expect(page).to have_content('Subscribe')
    end
  end

  describe 'User is authenticated' do
    given!(:question) { create(:question) }

    background do
      visit question_path(question)
    end

    scenario 'User can subscribe to question', js: true do
      expect(page).to_not have_content('Subscribe')
    end
  end
end