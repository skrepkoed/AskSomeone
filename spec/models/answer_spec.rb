require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  describe 'table_columns' do
    it {should have_db_column :body}
    it {should have_db_index :question_id}
    it {should have_db_index :user_id}
  end

  describe 'validations' do
  	subject {FactoryBot.build(:answer)}
  	
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:question_id) }
    it { should validate_presence_of (:user_id) }
  end

  describe 'associations' do
  	subject {FactoryBot.build(:answer)}
  	
    it { should belong_to(:question).dependent(:destroy) }
  end
end
