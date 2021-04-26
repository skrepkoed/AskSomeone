require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'Question belongs to user' do
      let!(:question) { create(:question) }
      let!(:user) { question.author }

      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        login(user)
      end

      it 'hasn`t attachment' do
        delete :destroy, params: { question_id: question.id, id: question.files.first.id }, format: :js
        expect(assigns(:attachment).persisted?).to be false
      end

      it 'renders destroy.js.erb' do
        delete :destroy, params: { question_id: question.id, id: question.files.first.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Question doesn`t belong to user' do
      let!(:question) { create(:question) }
      let!(:user) { create(:user) }

      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        login(user)
      end

      it 'has attachment' do
        delete :destroy, params: { question_id: question.id, id: question.files.first.id }, format: :js
        expect(assigns(:attachment).persisted?).to eq true
      end

      it 'renders destroy.js.erb' do
        delete :destroy, params: { question_id: question.id, id: question.files.first.id }, format: :js
        expect(flash[:notice]).to eq 'You must be author to delete attachment'
      end
    end

    context 'Answer belongs to user' do
      let!(:answer) { create(:answer) }
      let!(:user) { answer.author }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        login(user)
      end

      it 'hasn`t attachment' do
        delete :destroy, params: { answer_id: answer.id, id: answer.files.first.id }, format: :js
        expect(assigns(:attachment).persisted?).to be false
      end

      it 'renders destroy.js.erb' do
        delete :destroy, params: { answer_id: answer.id, id: answer.files.first.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Answer doesn`t belong to user' do
      let!(:answer) { create(:answer) }
      let!(:user) { create(:user) }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        login(user)
      end

      it 'has attachment' do
        delete :destroy, params: { answer_id: answer.id, id: answer.files.first.id }, format: :js
        expect(assigns(:attachment).persisted?).to eq true
      end

      it 'renders destroy.js.erb' do
        delete :destroy, params: { answer_id: answer.id, id: answer.files.first.id }, format: :js
        expect(flash[:notice]).to eq 'You must be author to delete attachment'
      end
    end
  end
end
