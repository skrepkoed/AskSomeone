require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question){ create(:question) }

  describe 'GET #new' do
    before { get :new }
    
    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has new question variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      it 'saves new question in DB' do
        expect{ post :create, params:{ question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params:{question: attributes_for(:question)}
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attrubutes' do
      it 'doesn`t save question if attrubutes are invalid' do
        expect{post :create, params:{ question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'renders :new if attrubutes are invalid' do
        post :create, params:{ question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

end
