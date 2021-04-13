FactoryBot.define do
  factory :question do
    association :author, factory: :user
    title { 'MyTitle' }
    body { 'My Question' }

    trait :invalid do
      title { '' }
      body { '' }
    end

    trait :for_create do
      title { 'MyTitle' }
      body { 'My Question' }
    end

    trait :with_answer do
      title { 'MyTitle' }
      body { 'My Question' }
      after :create do |question|
        create_list :answer, 3, :for_create, question_id: question.id
      end
    end
  end
end
