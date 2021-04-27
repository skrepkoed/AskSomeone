require 'rails_helper'

RSpec.describe Vote, type: :model do
  
  describe 'association' do
    subject{ build :vote }
    it { should belong_to :votable }
    it { should belong_to :user }
  end
=begin 
  describe 'validations' do
    let(:question){ create(:question) }
    subject{ build :vote, votable_id:question.id, votable_type:question.class }
    it { should validate_uniqueness_of(:votable_id).scoped_to( :user_id) }
  end
=end
end
