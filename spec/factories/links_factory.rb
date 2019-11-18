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

  trait :gist do
    url { 'https://gist.github.com/EfremovEvgeniy/4d7ba68e703433abb537d9c193b0af4c' }
  end
end
