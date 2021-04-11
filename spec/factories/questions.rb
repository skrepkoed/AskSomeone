FactoryBot.define do
  factory :question do
    title { 'MyTitle' }
    body { 'MyText' }

    trait :invalid do
      title {''}
      body {''}
    end

    trait :with_answer do
      title { 'MyTitle' }
      body { 'MyText' }
      after :create do |question|
        create :answer, :for_create, question_id: question.id
      end
    end
  end
end
