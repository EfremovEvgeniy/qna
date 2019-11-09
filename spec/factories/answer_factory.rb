FactoryBot.define do
  factory :answer do
    body { 'MyAnswerBody' }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
