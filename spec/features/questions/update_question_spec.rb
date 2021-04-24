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
      
      describe 'Delete link', js:true do
        
        given!(:question) { create(:question) }
        given!(:link1){ create(:link, linkable_type: 'Question', linkable_id: question.id) }
        given!(:link2){ create(:link, linkable_type:'Question', linkable_id: question.id) }
        given!(:user) { question.author }
        background{visit question_path(question)}
        scenario 'User can delete links while update' do
          expect(page).to have_content 'MyUrl1'
          expect(page).to have_content 'MyUrl2'
          
          click_on 'Edit question'
          
          within all(".question_edit_hidden #links .nested-fields").last do
            click_on 'remove link'
          end
          
          click_on 'Edit'
          
          expect(page).to_not have_content 'MyUrl2'
        end
      end
      
      describe 'Delete attachment', js: true do 
        given(:question) { create(:question) }
        given(:user) { question.author }
        
        background do
          question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename:'rails_helper.rb')
          visit question_path(question)
        end 
        
        scenario 'User can delete attached file' do
          within "#question-#{question.id}" do
            click_on 'Delete attachment'
          end
          expect(page).to_not have_link 'rails_helper.rb'
        end
      end
    end

    describe 'Question doesnt belong to user' do
      
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can`t edit another question', js: true do
        
        within "#question-#{question.id}" do
          expect(page).to_not have_link 'Edit question'
        end
      end
      
      describe 'Delete attachment', js: true do 
        given(:question) { create(:question) }
        given(:user) { create(:user) }
        
        background do
          question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename:'rails_helper.rb')
          visit question_path(question)
        end 
        
        scenario 'User can`t delete attached file' do
          expect(page).to_not have_link "Delete attachment"
        end
      end
    end
  end
end
