require 'rails_helper'

feature 'User can update question',
        "In order to change question as authenticated user I'd like
  to visit question`s show page and edit my question" do
  describe 'User is authenticated' do
    
    describe 'Question belongs to user', js: true do
      
      given(:question) { create(:question) }
      given(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can edit his own question' do
        click_on 'Edit question'
        
        within "#question-#{question.id}" do
          
          fill_in 'Body', with: 'Edited Question'
          click_on 'Edit'
        end
        expect(page).to_not have_link 'Edit', exact:true
        expect(page).to have_content 'Edited Question'
      end

      scenario 'User can attach file while update' do
        click_on 'Edit question'
        
        within "#question-#{question.id}" do      
          attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
          click_on 'Edit'
        end
        expect(page).to_not have_link 'Edit', exact:true
        expect(page).to have_link 'rails_helper.rb'
      end
      scenario 'User can attach several files while update' do
        click_on 'Edit question'
        
        within "#question-#{question.id}" do      
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Edit'
        end
        expect(page).to_not have_link 'Edit', exact:true
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    describe 'Question doesnt belong to user' do
      
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can edit his own answer', js: true do
        
        within "#question-#{question.id}" do
          expect(page).to_not have_link 'Edit question'
        end
      end
    end
  end
end
