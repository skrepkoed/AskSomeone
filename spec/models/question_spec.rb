require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'table_columns' do
    it { should have_db_column :body }
    it { should have_db_column :title }
    it { should have_db_column :best_answer_id }
  end

  describe 'associations' do
    subject { build(:question) }

    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:best_answer).class_name('Answer').optional }
    it { should belong_to(:author).class_name('User') }
    it { should accept_nested_attributes_for :links }
    it { should have_and_belong_to_many(:subscribers).join_table(:subscriptions).class_name('User') }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  describe '#today_questions' do
    let!(:questions){create_list :question, 3} 
    it 'reutrns questions created today' do
      questions.last.update(created_at:Time.now-1.day)
      expect(Question.today_questions.count).to eq 2 
    end 
  end

  describe '.subscribe' do
    subject { build(:question) }

    it 'creates subscription for author after question was created' do
      subject.save
      expect(subject.subscriptions.find_by(user_id: subject.author)).to be_present
    end
  end

  describe 'validations' do
    subject { build(:question) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
  end
end
