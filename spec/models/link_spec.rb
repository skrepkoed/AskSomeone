require  'rails_helper'

RSpec.describe Answer, type: :model do
  subject { build(:link) }

  describe 'columns' do
    it {should have_db_column :name}
    it {should have_db_column :url}
  end
  describe 'associations' do
    it{ should belong_to :linkable}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :url}
  end
end
