require 'rails_helper'

feature 'User can sign in', "
  As an unauthenticated user
  I'd like to be able to sign in
" do
  scenario 'Registred user tries to sign in' do
    User.create!(email: 'user@test.com', password: 'password')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
  scenario 'Unregistred user tries to sign in'
end
