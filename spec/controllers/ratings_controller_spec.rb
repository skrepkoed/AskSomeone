require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before do 
    login(user)
    post :pro, params: { question_id: question.id, id:question.rating.id }, format: :json
  end

  describe 'POST #pro' do
    it 'responds with 201 status' do
      expect(response.status).to eq(200)  
    end

    it 'responds with json' do
      expect(JSON.parse(response.body)).to be_kind_of(Hash)
    end
    
  end
end
