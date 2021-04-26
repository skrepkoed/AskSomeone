FactoryBot.define do
  sequence :name do |n|
    "MyUrl#{n}"
  end

  factory :link do
    name
    url { 'https://www.google.com/' }
  end
end
