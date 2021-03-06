require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'association' do
    subject { build :rating }
    it { should belong_to :ratingable }
    it { should have_many :votes }
  end

  describe 'instance methods' do
    include_context 'for rating'
    let!(:rating) { question.rating }

    describe '#voted?' do
      describe 'user voted ' do
        it 'give back Voted' do
          question.rating.find_user_vote(user).account_vote(variant)
          expect(rating.voted?(user, variant)).to eq('Voted')
        end

        it 'give back Revote' do
          question.rating.find_user_vote(user).account_vote(variant)
          expect(rating.voted?(user, -1)).to eq('Revote')
        end
      end

      describe 'user hasn`t voted' do
        it 'give back false' do
          expect(rating.voted?(user, variant)).to be false
        end
      end
    end
  end
end
