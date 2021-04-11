FactoryBot.define do
  factory :answer do
    question
    body { 'My Answer' }
  end

  trait :for_create do
    body {'My Answer'}
  end

  trait :invalid do
    body {''}
  end
end
