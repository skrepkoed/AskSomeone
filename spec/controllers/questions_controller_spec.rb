require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }

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
        end.to_not change(Question, :count)
      end

      it 'renders :new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question.id } }

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
        get :show, params: { id: question.id }
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
      let(:user) { create(:user, :with_question) }

      before { login(user) }

      it 'destroys question' do
        expect do
          delete :destroy,
                 params: { id: user.questions.first.id }
        end.to change(user.questions, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: user.questions.first.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'question doesn`t belong to user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question) }

      before { login(user) }

      it 'doesn`t destroy question' do
        expect { delete :destroy, params: { id: question.id } }.to_not change(Question, :count)
      end

      it 'renders question`s show view' do
        delete :destroy, params: { id: question.id }
        expect(response).to render_template :show
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let!(:user){ question.author }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Question doesn`t belong to user' do |variable|
      let!(:question) { create(:question) }
      let!(:user) { create(:user) }
      before { login(user) }
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :body)
      end
    end
  end

  describe 'PATCH #mark_best' do
    context 'Question belongs to user' do
      let!(:question) { create(:question, :with_answer) }
      let!(:user) { question.author }

      before { login(user) }

      it 'has best answer' do
        patch :mark_best, params: { question_id: question.id, answer_id: question.answers.first.id }, format: :js
        expect(assigns(:question).best_answer).to eq question.answers.first
      end

      it 'renders mark_best.js.erb' do
        patch :mark_best, params: { question_id: question.id, answer_id: question.answers.first.id }, format: :js
        expect(response).to render_template :mark_best
      end
    end

    context 'Question doesn`t belong to user' do
      let!(:question) { create(:question, :with_answer) }
      let!(:user) { create(:user) }

      before { login(user) }

      it 'has best answer' do
        patch :mark_best, params: { question_id: question.id, answer_id: question.answers.first.id }, format: :js
        expect(assigns(:question).best_answer).to eq nil
      end

      it 'renders mark_best.js.erb' do
        patch :mark_best, params: { question_id: question.id, answer_id: question.answers.first.id }, format: :js
        expect(flash[:notice]).to eq 'You must be author to mark answer as best'
      end
    end
  end
end
