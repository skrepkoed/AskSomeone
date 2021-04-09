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

end
