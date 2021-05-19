require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'association' do
    subject { build :vote }
    it { should belong_to :rating }
    it { should belong_to :user }
  end

  describe 'validations' do
    let(:question) { create(:question) }
    subject { build :vote, rating_id: question.rating.id, user_id: question.author.id }
    it { should validate_uniqueness_of(:rating_id).scoped_to(:user_id).with_message('You can vote only once') }

    describe '#impossible_to_vote_with_same_variant' do
      include_context 'for rating'

      let(:vote) { question.rating.find_user_vote(user).account_vote(variant) }

      it ' make impossible to vote twice with same variant' do
        vote.account_vote(variant)
        expect(vote.errors.full_messages[0]).to eq 'Variant You can vote only once'
      end
    end
  end
  describe 'instance methods' do
    include_context 'for rating'
    describe '#account_vote' do
      it 'account user`s vote' do
        question.rating.find_user_vote(user).account_vote(1)
        expect(question.rating.rating).to eq(1)
      end
    end
    describe '#voted' do
      let(:vote) { question.rating.find_user_vote(user).account_vote(variant) }
      it 'returns how user voted and how he can revote' do
        expect(vote.voted(-1)).to eq('Revote')
        expect(vote.voted(1)).to eq('Voted')
      end
    end

    describe '#unvote' do
      let(:vote) { question.rating.find_user_vote(user).account_vote(variant) }
      it 'unvote given vote' do
        vote.variant = -1
        vote.unvote
        expect(vote.persisted?).to be false
      end
    end
  end
end
