FactoryBot.define do
  sequence :email do |n|
    "somemail#{n}@gmail.com"
  end
  factory :user do
    email
    password {'1234567'}
    password_confirmation {'1234567'}
  end

  trait :with_question do
    email
    password {'1234567'}
    password_confirmation {'1234567'}
    after :create do |user|
      create :question, :for_create, user_id: user.id
    end
  end
end
