require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has new answer instance' do
      get :new, params: { question_id: question.id }
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'POST #create' do
    context 'with valid values' do
      it 'saves answers in DB' do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to render_template :show
      end
    end

    context 'with invalid values' do
      it 'saves answers in DB' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        end.to_not change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
