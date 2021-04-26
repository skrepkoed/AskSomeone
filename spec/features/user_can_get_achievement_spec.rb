require 'rails_helper'

feature 'User can get achievement',
        ' As user that has answered question and that question was marked as best
I`d like to recieve an achivement and get list of achievements ' do
  given!(:question) { create(:question) }

  given!(:user2) { question.author }
  given!(:user1) { create(:user) }

  given!(:answer) { create(:answer, :for_create, user_id: user1.id, question_id: question.id) }
  given!(:img_path) { "#{Rails.root}/public/apple-touch-icon.png" }
  given!(:achievement) { create(:achievement, user_id: user2.id, question_id: question.id) }
  given!(:img) { fixture_file_upload(img_path) }

  background do
    achievement.file.attach(img)
    question.mark_best_answer(answer)

    sign_in(user1)
    visit achievements_path
  end

  scenario 'User`s answer was marked as best' do
    expect(page).to have_content 'My Achievement'
    expect(page).to have_css("img[src*='apple-touch-icon.png']")
    expect(page).to have_content question.title
  end
end
