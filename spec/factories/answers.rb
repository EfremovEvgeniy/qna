FactoryBot.define do
  factory :answer do
    body { 'MyAnswerBody' }
    question { create(:question) }

    trait :invalid do
      body { nil }
    end
  end
end
