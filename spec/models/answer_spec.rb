require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'table_columns' do
    it { should have_db_column :body }
    it { should have_db_index :question_id }
  end

  describe 'associations' do
    subject { build(:answer) }

    it { should belong_to(:question) }
  end

  describe 'validations' do
    subject { build(:answer) }

    it { should validate_presence_of(:body) }
  end
end
