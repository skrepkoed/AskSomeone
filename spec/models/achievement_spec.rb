require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'associations' do
    it { should belong_to :question }
  end

  it 'has one attached file' do
    expect(Achievement.new.file).to be_instance_of ActiveStorage::Attached::One
  end
end
