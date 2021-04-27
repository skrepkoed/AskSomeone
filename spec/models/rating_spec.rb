require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'association' do
    subject{ build :rating }
    it { should belong_to :ratingable }
  end
end
