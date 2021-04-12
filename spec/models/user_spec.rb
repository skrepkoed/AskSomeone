require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject { build(:user) }
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end
end
