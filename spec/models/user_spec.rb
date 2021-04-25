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
        let(:user) { create(:user) }
        let(:question) { create(:question, user_id: user.id) }
        let(:answer) { create(:answer, user_id: user.id) }

        it 'returns true for answer instance' do
          expect(user.author?(answer)).to be true
        end

        it 'returns true for question instance' do
          expect(user.author?(question)).to be true
        end
      end

      context 'user isn`t author' do
        let(:user) { create(:user) }
        let(:question) { create(:question) }
        let(:answer) { create(:answer) }

        it 'returns false for answer instance' do
          expect(user.author?(answer)).to be false
        end

        it 'returns false for question instance' do
          expect(user.author?(question)).to be false
        end
      end
    end

    describe 'associate_achievement associate achievement if it`s not nil' do
      context 'Achievement not nill' do
        let(:user) { create(:user) }
        let(:question) { create(:question, user_id: user.id) }
        let(:achievement) { create(:achievement, question_id: question.id) }

        it 'associate achievement with user' do
          expect { user.associate_achievement(achievement) }.to change(user.achievements, :count).by(1)
        end
      end
      context 'Achievement nill' do
        let(:user) { create(:user) }
        let(:question) { create(:question, user_id: user.id) }
        let(:achievement) { nil }

        it 'associate achievement with user' do
          expect { user.associate_achievement(achievement) }.to_not change(user.achievements, :count)
        end
      end
    end

    describe 'give_achievement give_achievement to user which answer is the best' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:question) { create(:question, user_id: user1.id) }
      let(:achievement) { create(:achievement, question_id: question.id, user_id: user1.id) }
      let(:answer) { create(:answer, user_id: user2.id, question_id: question.id) }

      it 'gives achievement to user' do
        expect { user1.give_achievement(answer.id, achievement) }.to change(user2.earned_achievements, :count).by(1)
      end
    end
  end
end
