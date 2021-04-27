FactoryBot.define do
  factory :vote do
    vote { 1 }
    association :user
  end
end
