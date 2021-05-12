require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  describe 'when is a guest' do
    it { should be_able_to(:read, Question) }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end
  describe 'when is admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'for author' do
    let(:user) { create :user }
    let(:other) { create :user }

    let(:user_question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:user_answer) { create(:answer, author: user) }
    let(:other_answer) { create(:answer, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'Update' do
      it { should be_able_to :update, user_question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, user_answer }
      it { should_not be_able_to :update, other_answer }
    end

    context 'Destroy' do
      it { should be_able_to :destroy, user_question }
      it { should_not be_able_to :destroy, other_question }

      it { should be_able_to :destroy, user_answer }
      it { should_not be_able_to :destroy, other_answer }
    end

    context 'Attachment' do
      before do
        user_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        user_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')

        other_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        other_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end

      it { should be_able_to :destroy, user_answer.files.first }
      it { should be_able_to :destroy, user_question.files.first }

      it { should_not be_able_to :destroy, other_answer.files.first }
      it { should_not be_able_to :destroy, other_question.files.first }
    end

    context 'Vote' do
      it { should be_able_to :vote, other_question.rating }
      it { should_not be_able_to :vote, user_question.rating }

      it { should be_able_to :vote, other_answer.rating }
      it { should_not be_able_to :vote, user_answer.rating }
    end

    context 'Mark best' do
      it { should be_able_to :mark_best, user_question }
      it { should_not be_able_to :mark_best, other_question }
    end
  end
end
