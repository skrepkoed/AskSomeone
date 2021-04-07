FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
    user_id {"2"}
  end
end
