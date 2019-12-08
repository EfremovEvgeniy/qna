require 'rails_helper'

feature 'User can sign in with github', "
  as User
  I'd like to be able to sign in  with github
" do
  describe 'User signs in with GitHub' do
    given!(:user) { create(:user) }

    background { visit new_user_registration_path }

    it 'shows links to sign in with github' do
      expect(page).to have_link 'Sign in with GitHub'
    end

    it 'logins user with github' do
      mock_auth :github, 'user@mail.ru'
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end
  end
end
