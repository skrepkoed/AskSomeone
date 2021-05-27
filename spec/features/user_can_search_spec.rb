require 'sphinx_helper'

feature 'User can search for answer', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do 
  before do
    user ||= User.create(email:'user123456@gmail.com', password:'12345678',password_confirmation:'12345678')
    #byebug
    question ||= user.questions.create(body:'Question',title:'title')
    answer ||= question.answers.create(body:'Answer', author:user)
    comment ||= question.comments.create(body:'Comment', author:user)
    another_answer ||= question.answers.create(body:'Question', author:user)
  end
  scenario 'User searches for the answer', sphinx: true, js:true do
    visit search_new_path
    select 'Answers', from: 'inputGroupSelect01'
    fill_in 'search', with: 'Answer'
    ThinkingSphinx::Test.run do
      click_on 'Search'
      expect(page).to have_content 'Answer'
    end
    #User.destroy_all
  end

  scenario 'User searches for the question', sphinx: true, js:true do
    visit search_new_path

    select 'Questions', from: 'inputGroupSelect01'
    fill_in 'search', with: 'Question'
    ThinkingSphinx::Test.run do
      click_on 'Search'
      expect(page).to have_content 'Question'
    end
    #User.destroy_all
  end

  scenario 'User searches for the comment', sphinx: true, js:true do
    visit search_new_path

    select 'Comments', from: 'inputGroupSelect01'
    fill_in 'search', with: 'Comment'
    ThinkingSphinx::Test.run do
      click_on 'Search'
      expect(page).to have_content 'Comment'
    end
    #User.destroy_all
  end
  scenario 'User searches for the user', sphinx: true, js:true do
    visit search_new_path

    select 'Users', from: 'inputGroupSelect01'
    fill_in 'search', with: 'user123456'
    ThinkingSphinx::Test.run do
      click_on 'Search'
      expect(page).to have_content 'user123456@gmail.com'
    end
    #User.destroy_all
  end

  scenario 'User searches in all categoriesr', sphinx: true, js:true do
    visit search_new_path
    select 'All', from: 'inputGroupSelect01'
    fill_in 'search', with: 'Question'
    ThinkingSphinx::Test.run do
      click_on 'Search'
      expect(page).to have_content 'Answer'
      expect(page).to have_content 'Question'
    end
   #User.destroy_all
   
  end
end