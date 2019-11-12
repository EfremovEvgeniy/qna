FactoryBot.define do
  factory :question do
    title { 'MyQuestionTitle' }
    body { 'MyQuestionBody' }
    user

    trait :invalid do
      title { nil }
    end

    trait :attachment_file do
      files { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
    end

    factory :question_with_answer do
      after(:create) do |question|
        create(:answer, question: question)
      end
    end
  end
end
