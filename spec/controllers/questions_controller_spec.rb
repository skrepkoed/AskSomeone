require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has new question instance' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      it 'saves new question in DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'render to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attrubutes' do
      it 'doesn`t save question ' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 'renders :new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show'do
    before { get :show, params:{id: question.id } }
    it 'renders show view' do
      expect(response).to render_template :show
    end
    it 'has question instance with requested id' do
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }
    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'has array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
  end
end
