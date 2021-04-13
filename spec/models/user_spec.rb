require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject { build(:user) }
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe 'instance methods' do
    
    describe '#author? proves that user is author of some resource ' do
      
      context 'user is author' do
        let(:user){ create(:user) }
        let(:question){ create(:question, user_id: user.id) }
        let(:answer){ create(:answer, user_id: user.id) }

        it 'returns true for answer instance' do
          expect(user.author?(answer)).to be true
        end

        it 'returns true for question instance' do
          expect(user.author?(question)).to be true
        end
      end

      context 'user isn`t author' do
        let(:user){ create(:user) }
        let(:question){ create(:question) }
        let(:answer){ create(:answer) }

        it 'returns false for answer instance' do
          expect(user.author?(answer)).to be false
        end

        it 'returns false for question instance' do
          expect(user.author?(question)).to be false
        end
      end
    end
  end
end
