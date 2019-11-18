FactoryBot.define do
  factory :trophy do
    sequence(:name) { |n| "name#{n}" }
  end
end
