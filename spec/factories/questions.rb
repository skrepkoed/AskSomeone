FactoryBot.define do
  factory :question do
    association :author, factory: :user
    title { 'MyTitle' }
    body { 'My Question' }

    after :create do |question|
      create :rating, ratingable_id: question.id, ratingable_type: 'Question'
      create :link, linkable_id: question.id, linkable_type: 'Question'
    end
  end

  trait :invalid_question do
    title { '' }
    body { '' }
  end

  trait :for_create_answer do
    title { 'MyTitle' }
    body { 'My Question' }
  end

  trait :with_answer do
    title { 'MyTitle' }
    body { 'My Question' }
    after :create do |question|
      create_list :answer, 3, :for_create, question_id: question.id, user_id: question.author.id
    end
  end
end
