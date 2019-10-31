FactoryBot.define do
  factory :answer do
    body { 'MyAnswerBody' }
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
