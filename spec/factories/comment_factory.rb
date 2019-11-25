FactoryBot.define do
  factory :comment do
    body { 'comment' }
  end

  trait :invalid_comment do
    body { nil }
  end
end
