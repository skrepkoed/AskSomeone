require 'rails_helper'

feature 'User can vote for answer or question',
        'In order to vote for useful answer or question
  as authenticated user I`d like to visit question`s show page
  and vote for question or answer ', js: true do
  describe 'User authenticated' do
    describe 'User can vote for question' do
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User vote for question and counter increments' do
        expect(page).to have_content 'Rating: 0'
        click_on 'Vote pro'
        expect(page).to have_content 'Rating: 1'
      end

      scenario 'User can`t vote twice with same variant' do
        click_on 'Vote pro'
        click_on 'Voted'
        expect(page).to have_content 'You can vote only once'
      end

      scenario 'User can unvote and vote again', js: true do
        click_on 'Vote pro'
        click_on 'Revote'
        expect(page).to have_content 'Rating: 0'
        click_on 'Vote con'
        expect(page).to have_content 'Rating: -1'
      end
    end

    describe 'User can vote for answer' do
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User vote for answer and counter increments' do
        within('.answers') do
          expect(page).to have_content 'Rating: 0'
          click_on 'Vote pro'
          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'User can`t vote twice with same variant', js: true do
        within all('.answer').first do
          click_on 'Vote pro'
          click_on 'Voted'
          expect(page).to have_content 'You can vote only once'
        end
      end

      scenario 'User can unvote and vote again', js: true do
        within('.answers') do
          click_on 'Vote pro'
          click_on 'Revote'
          expect(page).to have_content 'Rating: 0'
          click_on 'Vote con'
          expect(page).to have_content 'Rating: -1'
        end
      end

      describe 'User can`t vote for his own answer' do
        given!(:answer) { create(:answer) }
        given!(:user) { answer.author }
        given!(:question) { answer.question }

        scenario 'User can`t vote for his own question' do
          within('.answers') do
            expect(page).to have_content 'Rating: 0'
            expect(page).to_not have_content 'Vote pro'
          end
        end
      end
    end

    describe 'User can`t vote for his own question' do
      given!(:question) { create(:question) }
      given!(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User vote for question and counter increments' do
        expect(page).to have_content 'Rating: 0'
        expect(page).to_not have_content 'Vote pro'
      end
    end
  end

  describe 'User isn`t authenticated' do
    describe 'User can`t vote for question' do
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do
        visit question_path(question)
      end

      scenario 'User vote for question and counter doesn`t increment' do
        expect(page).to have_content 'Rating: 0'
        expect(page).to_not have_content 'Vote pro'
      end
    end
    describe 'User can`t vote for answer' do
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      background do
        visit question_path(question)
      end

      scenario 'User vote for question and counter doesn`t increment' do
        expect(page).to have_content 'Rating: 0'
        expect(page).to_not have_content 'Vote pro'
      end
    end
  end
end
