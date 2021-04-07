require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
  	subject { FactoryBot.build(:question) }

  	it { should validate_presence_of(:title) }
  	it { should validate_presence_of(:body) }
  	it { should validate_length_of(:body).is_at_least(5) }
  end

  describe 'associations' do
  	subject { FactoryBot.build(:question) }
  	it { should have_many(:answers) }
  end
end
