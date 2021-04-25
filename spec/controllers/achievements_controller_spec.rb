require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  let!(:user1) { create(:user) }

  before { login(user1) }

  describe 'GET #index' do
    let!(:question) { create(:question) }
    let!(:user2) { question.author }

    let!(:answer) { create(:answer, :for_create, user_id: user1.id, question_id: question.id) }
    let!(:img_path) { "#{Rails.root}/public/apple-touch-icon.png" }
    let!(:achievement) { create(:achievement, user_role: 'questioner', user_id: user2.id, question_id: question.id) }
    let!(:img) { fixture_file_upload(img_path) }

    before { get :index }

    it 'renders index' do
      get :index
      expect(response).to render_template :index
    end

    it 'returns achievement collection' do
      achievement.file.attach(img)
      question.mark_best_answer(answer.id)

      get :index
      expect(assigns(:achievements)).to match_array(user1.earned_achievements)
    end
  end
end
