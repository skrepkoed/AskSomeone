require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe "POST #create" do
    let!(:question){create(:question)}
    let(:user) { create(:user) }
    let(:another_question){ create(:question) }
    before do
      login(user)
      post :create, params: { question_id: question.id },
                      format: :js
    end
    
    it 'creates subscription' do
      expect do
        post :create, params: { question_id: another_question.id },
                      format: :js
      end.to change(Subscription, :count).by(2)
    end

    it 'assigns subscription' do
      expect(assigns(:subscription)).to be_a(Subscription)
    end

    it 'renders subscription' do
      expect(response).to render_template :subscription
    end
  end

  describe "DELETE #destroy" do
    
    let!(:question){ create(:question) }
    let(:user) { question.author }
    before{ login(user) }
    it "destroys subscription" do
      expect do
          delete :destroy,
                 params: { question_id: question.id, id: question.subscriptions.first.id }, format: :js
        end.to change(Subscription, :count).by(-1)
    end
  end
end
