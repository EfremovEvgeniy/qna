require 'rails_helper'

feature 'User can delete his question', "
  As an authenticated user
  I'd like to be able to delete my question
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
      expect(page).to have_link('Delete')
      click_on 'Delete'
      expect(page).to have_no_content user.questions.first.title
      expect(page).to have_no_link('Delete')
    end
  end
end
