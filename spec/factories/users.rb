FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { 'password' }
    password_confirmation { 'password' }

    factory :user_with_question do
      after(:create) do |user|
        create(:question, user: user)
      end
    end
    factory :user_with_question_with_answer do
      after(:create) do |user|
        create(:question_with_answer, user: user)
      end
    end
  end
end
