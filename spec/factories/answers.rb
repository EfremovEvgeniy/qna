FactoryBot.define do
  factory :answer do
    body { 'MyAnswerBody' }
    question { create(:question) }
    user { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
