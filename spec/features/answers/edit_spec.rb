require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
  " do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(answer.user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_selector('textarea')
      end
    end

    scenario 'edits his answer with errors'
    scenario 'tries to edit other '
  end
end
