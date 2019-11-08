require 'rails_helper'

feature 'User can sign up', "
  As an unauthenticated and unregistred user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit root_path }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit root_path
    end
    scenario 'tryes to sign up' do
      expect(page).to have_no_link('Sign up')
    end
  end

  scenario 'Unregistred user goes to sign up' do
    expect(page).to have_link('Sign up')

    click_on 'Sign up'
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Password', with: 'password28'
    fill_in 'Password confirmation', with: 'password28'
    click_on 'Join QnA'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registred but unauthenticated user goes to sign up' do
    expect(page).to have_link('Sign up')

    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Join QnA'

    expect(page).to have_content 'Email has already been taken'
  end
end
