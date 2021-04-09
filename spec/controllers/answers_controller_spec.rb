require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer){ create(:answer) }
  let(:question){create(:question)}
  describe 'GET #new' do
    before{ get :new, params: { question_id: answer.question } }
    
    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'has new answer instance' do
      get :new, params: {question_id: question.id}
      expect( assigns(:answer) ).to be_a_new(Answer)
    end

  end
end
