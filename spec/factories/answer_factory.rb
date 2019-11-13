FactoryBot.define do
  factory :answer do
    body { 'MyAnswerBody' }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }
    end

    trait :best do
      best { true }
    end
  end
end
