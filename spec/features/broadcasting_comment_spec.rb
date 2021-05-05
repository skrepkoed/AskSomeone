require 'rails_helper'

feature 'User can automatically get new comment', 
  %q{In order to get comment immediately as authenticated User
    I`d like to visit question page and if 
    someone commented question or answer than comment appears on page  }, js:true do
  given(:answer){ create(:answer) }
  given(:question){ answer.question }
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

  scenario 'Coment for question appears on page when someone commented question' do
    Capybara.using_session('user2') do
      within ("#question-#{question.id} .comments_container") do
        fill_in 'Comment', with: 'Comment body'
        click_on 'Comment'
        expect(page).to have_content('Comment body')
      end
    end

    Capybara.using_session('user1') do
      within ("#question-#{question.id} .comments_container") do
        expect(page).to have_content('Comment body')
      end
    end
  end

  scenario 'Comment for answer appears on page when someone commented question' do
    Capybara.using_session('user2') do
      within ("#answer-#{answer.id} ") do
        fill_in 'Comment', with: 'Comment body'
        click_on 'Comment'
        expect(page).to have_content('Comment body')
      end
    end

    Capybara.using_session('user1') do
      within ("#answer-#{answer.id} .comments_container") do
        expect(page).to have_content('Comment body')
      end
    end
  end
end