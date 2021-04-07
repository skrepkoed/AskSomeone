require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  describe 'validations' do
  	subject {FactoryBot.build(:answer)}
  	
    it { should validate_presence_of(:body) }
  end

  describe 'associations' do
  	subject {FactoryBot.build(:answer)}
  	
    it { should belong_to(:question).dependent(:destroy) }
  end
end
