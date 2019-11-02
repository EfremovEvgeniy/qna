require 'rails_helper'

feature 'User can delete only his answer', "
  As an authenticated user
  I'd like to be able to delete only my answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'delete his answer' do
      visit question_path(question)
      fill_in 'Body', with: 'my awesome answer'
      click_on 'Save'
      expect(page).to have_link('delete')
      click_on 'delete'
      expect(page).to have_no_link('delete')
    end
  end
end
