FactoryBot.define do
  sequence :body do |n|
    "My Answer#{n}"
  end
  factory :answer do
    question
    association :author, factory: :user
    body { 'My Answer' }
  end

  trait :for_create do
    body
  end

  trait :invalid do
    body { '' }
  end
end
