require 'rails_helper'

feature 'User can delete only his answer', "
  As an authenticated user
  I'd like to be able to delete only my answer
" do
  given(:answer) { create(:answer) }
  given!(:question_with_answer) { create(:question_with_answer) }

  describe 'Authenticated user' do
    background do
      sign_in(answer.user)
    end

    scenario 'delete his answer' do
      visit question_path(answer.question)
      expect(page).to have_content answer.body
      expect(page).to have_link('Delete')
      click_on 'Delete'
      expect(page).to have_no_content answer.body
    end

    scenario 'tries to delete not his own answer' do
      visit question_path(question_with_answer)
      expect(page).to have_no_link('Delete')
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question_with_answer)
    expect(page).to have_content 'You need to sign in to write your answer'
    expect(page).to have_no_link('Delete')
  end
end
