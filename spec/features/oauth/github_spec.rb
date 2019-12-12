require 'rails_helper'

feature 'User can sign in with github', "
  as User
  I'd like to be able to sign in  with github
" do
  describe 'User signs in with GitHub' do
    given!(:user) { create(:user) }

    background { visit new_user_registration_path }

    describe 'login with github' do
      scenario 'existing user' do
        mock_auth :github, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'does not existing user' do
        mock_auth :github, email: 'new@gmail.com'
        click_on 'Sign in with GitHub'
        open_email 'new@gmail.com'
        current_email.click_link 'Confirm my account'

        expect(page).to have_content 'Your email address has been successfully confirmed'

        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end
  end
end
