require 'rails_helper'

feature 'User can sign in with vkontakte', "
  as User
  I'd like to be able to sign in  with vkontakte
" do
  describe 'User signs in with Vkontakte' do
    given!(:user) { create(:user) }

    background { visit new_user_registration_path }

    scenario 'shows links to sign in with vkontakte' do
      expect(page).to have_link 'Sign in with Vkontakte'
    end

    describe 'login with vkontakte' do
      scenario 'existed user' do
        mock_auth :vkontakte
        click_on 'Sign in with Vkontakte'

        fill_in 'Email', with: user.email
        click_on 'save'

        click_on 'Sign in with Vkontakte'

        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario 'user does not exist' do
        mock_auth :vkontakte
        click_on 'Sign in with Vkontakte'
        fill_in 'Email', with: 'new@gmail.com'
        click_on 'save'
        open_email 'new@gmail.com'
        current_email.click_link 'Confirm my account'

        expect(page).to have_content 'Your email address has been successfully confirmed'

        visit new_user_registration_path
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end
    end
  end
end
