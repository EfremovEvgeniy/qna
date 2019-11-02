require 'rails_helper'

feature 'User can delete only his question', "
  As an authenticated user
  I'd like to be able to delete only my question
" do
  given(:user) { create(:user_with_question) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit root_path
    end

    scenario 'delete his question' do
      expect(page).to have_content user.questions.first.title
      expect(page).to have_content question.title
      expect(page).to have_link('delete')
      click_on 'delete'
      expect(page).to have_no_link('delete')
    end
  end
end
