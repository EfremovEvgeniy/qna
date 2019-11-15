FactoryBot.define do
  sequence :name do |n|
    "MyLink_#{n}"
  end

  factory :link do
    name
    url { 'https://github.com/EfremovEvgeniy' }
  end

  trait :invalid do
    url { 'invalid/link' }
  end
end
