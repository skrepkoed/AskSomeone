require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user){create(:user)}
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  before {login(user)}
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
          post :create, params: { question_id: question.id, answer: attributes_for(:answer,:for_create) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirect to question`s show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :for_create) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid values' do
      it 'doesn`t saves answers in DB' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        end.to_not change(question.answers, :count)
      end

      it 'renders question`s show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show', layout: :application
      end
    end
  end
end
