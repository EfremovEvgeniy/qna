FactoryBot.define do
  factory :question do
    title { 'MyQuestionTitle' }
    body { 'MyQuestionBody' }

    trait :invalid do
      title { nil }
    end

    factory :question_with_answer do
      after(:create) do |question|
        create(:answer, question: question)
      end
    end
  end
end
