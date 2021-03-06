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
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  it 'should have many attached files' do
    expect(Answer.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  describe 'validations' do
    subject { build(:answer) }

    it { should validate_presence_of(:body) }
  end

  describe 'instance methods' do
    describe '.best_answer?' do
      let!(:answer) { create(:answer) }
      let!(:question) { answer.question }
      context 'answer is the best' do
        it 'should be the best answer' do
          question.mark_best_answer(answer)
          expect(answer.best_answer?).to be true
        end
      end

      context 'answer isn`t best' do
        it 'should not be the best answer' do
          expect(answer.best_answer?).to be false
        end
      end
    end

    describe 'before_destroy callback' do
      let!(:answer) { create(:answer) }
      let!(:question) { answer.question }
      it 'should not have the best answer' do
        question.mark_best_answer(answer)
        answer.destroy
        expect(question.best_answer).to be nil
      end
    end
  end

  describe 'notify_about_answer' do
    subject{ build(:answer) }
    it 'should notify about new answer' do
      expect(QuestionNotifyJob).to receive(:perform_later)
      subject.save
    end
  end
end
