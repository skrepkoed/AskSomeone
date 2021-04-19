require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'table_columns' do
    it { should have_db_column :body }
    it { should have_db_index :question_id }
  end

  describe 'associations' do
    subject { build(:answer) }

    it { should belong_to(:question) }
    it { should belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    subject { build(:answer) }

    it { should validate_presence_of(:body) }
  end

  describe 'instance methods' do
    
    describe 'best_answer?' do
      
      context 'answer is the best' do 
          let!(:answer){create(:answer)}
          let!(:question){answer.question}
          
        it 'should be the best answer' do
          question.mark_best_answer(answer.id)
          expect(answer.best_answer?).to be true 
        end
      end
      
      context 'answer isn`t best' do
          let(:answer){create(:answer)}
          let(:question){answer.question}
        
        it 'should be the best answer' do
          expect(answer.best_answer?).to be false 
        end
      end
    end

    describe 'before_destroy callback' do
        let(:answer){create(:answer)}
        let(:question){answer.question}
      
      it 'should be the best answer' do
        question.mark_best_answer(answer.id)
        answer.destroy
        expect(question.best_answer).to be nil 
      end
    end
  end
end
