FactoryBot.define do
  factory :authorization do
    user
    provider { 'MyProviderName' }
    uid { 'MyUid' }
  end
end
