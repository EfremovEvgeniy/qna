require 'rails_helper'

feature 'User can log out', "
  As an authenticated user
  I'd like to be able to log out
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit root_path
    end

    scenario 'can log out' do
      expect(page).to have_link('Log out')

      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'
    end
  end

  scenario 'Unauthenticated user can not log out' do
    visit root_path

    expect(page).to have_no_link('Log out')
  end
end
