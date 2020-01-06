require 'rails_helper'

feature 'User with admin email can see sidekiq web' do
  given(:user) { create(:user) }
  given(:admin) { create(:user, email: 'johne32rus23@gmail.com') }

  describe 'Authenticated user' do
    scenario 'with admin email'
    scenario 'with not admin email'
  end

  describe 'Unauthenticated user' do
    scenario 'can not see sidekiq web'
  end
end