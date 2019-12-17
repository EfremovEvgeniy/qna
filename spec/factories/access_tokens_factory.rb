FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    association :application, factory: :oauth_application
    resource_owner_id { create(:user).id }
    scopes { Doorkeeper.configuration.scopes.first.to_sym }
  end
end
