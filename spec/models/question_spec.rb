require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'table_columns' do
    it { should have_db_column :body }
    it { should have_db_column :title }
  end

  describe 'associations' do
    subject { build(:question) }

    it { should have_many(:answers) }
  end

  describe 'validations' do
    subject { build(:question) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
  end
end
