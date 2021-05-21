require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject { build(:user) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
  end

  describe 'instance methods' do
    describe '.author? proves that user is author of some resourse ' do
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
      describe '.subscribed?' do
        let!(:question){ create(:question) }
        let(:user){ question.author }
        it 'returns true if user subscribed' do
          expect(user.subscribed?(question)).to be true
        end
      end

      describe '.subscription' do
        let!(:question){ create(:question) }
        let(:user){ question.author }
        it 'returns subscription' do
          expect(user.subscription(question)).to be_present
        end
      end
    end

    describe '.associate_achievement associate achievement if it`s not nil' do
      context 'Achievement not nill' do
        let(:user) { create(:user) }
        let(:question) { create(:question, user_id: user.id) }
        let(:achievement) { create(:achievement, question_id: question.id) }

        it 'associate achievement with user' do
          expect { user.associate_achievement(achievement) }.to change(user.achievements, :count).by(1)
        end
      end
      context 'Achievement nil' do
        let(:user) { create(:user) }
        let(:question) { create(:question, user_id: user.id) }
        let(:achievement) { nil }

        it 'associate achievement with user' do
          expect { user.associate_achievement(achievement) }.to_not change(user.achievements, :count)
        end
      end
    end

    describe '#find_for_oauth' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      let(:service) { double('FindForOauth') }

      it 'calls FindForOauth' do
        expect(FindForOauth).to receive(:new).with(auth).and_return(service)
        expect(service).to receive(:call)
        User.find_for_oauth(auth)
      end
    end
  end
end
