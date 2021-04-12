FactoryBot.define do
  factory :answer do
    question
    association :author, factory: :user
    body { 'My Answer' }
  end

  trait :for_create do
    body { 'My Answer' }
  end

  trait :invalid do
    body { '' }
  end
end
