FactoryBot.define do
  factory :authorization do
    provider { 'MyString' }
    user { nil }
    uid { 'MyString' }
  end
end
