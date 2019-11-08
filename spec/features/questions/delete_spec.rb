require 'rails_helper'

feature 'User can delete only his question', "
  As an authenticated user
  I'd like to be able to delete only my question
" do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(question.user)
      visit root_path
    end

    scenario 'can delete his question' do
      expect(page).to have_content question.title
      expect(page).to have_link('delete')

      click_on 'delete'

      expect(page).to have_no_content question.title
      expect(page).to have_no_link('delete')
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit root_path

    expect(page).to have_no_link('delete')
  end
end
