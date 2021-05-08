require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    subject { build(:comment) }
    it { should belong_to(:commentable) }
    it { should belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    subject { build(:question) }
    it { should validate_presence_of(:body) }
  end

  describe 'instance methods' do
    describe 'question' do
      let(:answer) { create(:answer) }
      let(:question) { answer.question }
      let(:comment_for_question) { question.comments.create(body: 'Comment') }
      let(:comment_for_answer) { answer.comments.create(body: 'Comment') }
      it 'returns associated question' do
        expect(comment_for_question.question).to eq question
        expect(comment_for_answer.question).to eq question
      end
    end
  end
end
