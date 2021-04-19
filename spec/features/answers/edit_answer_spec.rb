require 'rails_helper'

feature 'User can edit his answer',
        'In order to change my answer, as authenticated user
I`d like to visit question`s show page and edit my answer' do
  describe 'User is authenticated' do
    describe 'User has answered this question before' do
      
      given(:answer) { create(:answer) }
      given(:user) { answer.author }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can edit his own answer', js: true do
        
        click_on 'Edit answer'
        
        within ".answers #answer-#{answer.id}" do
          fill_in 'Body', with: 'Edited Answer'
        end
        click_on 'Edit'
        expect(page).to_not have_link 'Edit', exact: true
        expect(page).to have_content 'Edited Answer'
      end

      scenario 'User can add file while edit his own answer', js: true do
        
        click_on 'Edit answer'
        
        within ".answers #answer-#{answer.id}" do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        end
        click_on 'Edit'
        expect(page).to_not have_link 'Edit', exact: true
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    describe "User hasn't answered this question before" do
      
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can`t edit another answers', js: true do
        expect(page).to_not have_content 'Edited Answer'
      end
    end
  end

  describe "User isn't authenticated" do
    
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    background { visit question_path(question) }

    scenario 'User can`t edit another answers', js: true do
      expect(page).to_not have_content 'Edited Answer'
    end
  end
end
