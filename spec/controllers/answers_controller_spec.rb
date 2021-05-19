require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  before { login(user) }

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
      let(:perform) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :for_create) },
                      format: :js
      end
      let(:resource_collection) { question.answers }
      it_behaves_like 'resource saved'

      it 'renders create.js.erb view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :for_create) },
                      format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid values' do
      it 'doesn`t saves answers in DB' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) },
               format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create.js.erb view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) },
                      format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'answer belongs to user' do
      let!(:answer) { create(:answer) }
      let!(:user) { answer.author }
      let!(:question) { answer.question }

      before { login(user) }

      it 'destroys question' do
        expect do
          delete :destroy,
                 params: { question_id: answer.question.id, id: user.answers.first.id }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'renders destroy.js.erb' do
        delete :destroy, params: { question_id: answer.question.id, id: user.answers.first.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'question doesn`t belong to user' do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer) }
      let!(:question) { answer.question }

      before { login(user) }

      it 'doesn`t destroy question' do
        expect do
          delete :destroy,
                 params: { question_id: answer.question.id, id: answer.id }, format: :js
        end.to_not change(Answer, :count)
      end

      it 'rendirects to root ' do
        delete :destroy, params: { question_id: answer.question.id, id: answer.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer) }
    let!(:user) { answer.author }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Answer doesn`t belong to user' do
      let!(:answer) { create(:answer) }
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end
end
