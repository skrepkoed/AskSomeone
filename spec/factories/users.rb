FactoryBot.define do
  sequence :email do |n|
    "somemail#{n}@gmail.com"
  end
  factory :user do
    email
    password {'1234567'}
    password_confirmation {'1234567'}
  end
end
