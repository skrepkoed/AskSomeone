require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user){create(:user)}
  before{login(user)}
  
  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has new question instance' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'has current user instance' do
      expect(controller.current_user).to eq user
    end
  end

  describe 'POST #create' do
    context 'with valid attrubutes' do
      it 'saves new question in DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
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
        end.to_not change(user.questions, :count)
      end

      it 'renders :new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show'do
    let(:question) { create(:question) }
    before { get :show, params:{id: question.id } }
    it 'renders show view' do
      expect(response).to render_template :show
    end
    it 'has question instance with requested id' do
      expect(assigns(:question)).to eq(question)
    end
    it 'has  new answer instance' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'has new answer instance that belongs to current question' do
      expect(assigns(:answer).question_id).to eq question.id
    end

    it 'has new answer instance that belongs to current question' do
      expect(assigns(:answer).author.id).to eq controller.current_user.id
    end

    context 'question has been answered' do
      before do 
        create(:question, :with_answer)
        get :show, params:{id: question.id}
      end

      it 'has array of answers' do
        expect(assigns(:answers)).to match_array question.answers
      end
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

  describe 'DELETE #destroy' do
    context 'question belongs to user' do 
      let(:user){create(:user, :with_question)}
      before{ login(user) }
      it 'destroys question' do
        expect {delete :destroy, params:{id:user.questions.first.id} }.to change(user.questions, :count).by(-1)
      end
    end

    context 'question doesn`t belong to user' do
      let(:user){ create(:user) }
      let(:question){create(:question)}
      before{ login(user) }

      it 'doesn`t destroy question' do
        expect {delete :destroy, params:{id:question.id} }.to_not change(user.questions, :count)
      end
    end
  end
end
