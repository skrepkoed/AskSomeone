require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  describe 'POST #pro' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    before do
      login(user)
      post :pro, params: { question_id: question.id, id: question.rating.id }, format: :json
    end

    it 'responds with 201 status' do
      expect(response.status).to eq(200)
    end

    it 'responds with json' do
      expect(JSON.parse(response.body)).to be_kind_of(Hash)
    end
  end

  describe 'POST #con' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:question) { answer.question }

    before do
      login(user)
      post :con, params: { answer_id: answer.id, id: answer.rating.id }, format: :json
    end

    it 'responds with 201 status' do
      expect(response.status).to eq(200)
    end

    it 'responds with json' do
      expect(JSON.parse(response.body)).to be_kind_of(Hash)
    end
  end
end
