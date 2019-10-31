require 'rails_helper'

feature 'User can see question page with answers', "
  In order to acquainted with question and answers
  As an authenticated or unauthenticated user
  I'd like to be able to see question page with answers
" do
  given(:user) { create(:user) }
  given(:question_with_answer) { create(:question_with_answer) }
  given(:question) { create(:question) }

  describe 'Unauthenticated user' do
    scenario 'can see question page without answers' do
      visit question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'can see question page with answers' do
      visit question_path(question_with_answer)
      expect(page).to have_content question_with_answer.title
      expect(page).to have_content question_with_answer.body
      expect(page).to have_content question_with_answer.answers.first.body
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can see question page without answers' do
      visit question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'can see question page with answers' do
      visit question_path(question_with_answer)
      expect(page).to have_content question_with_answer.title
      expect(page).to have_content question_with_answer.body
      expect(page).to have_content question_with_answer.answers.first.body
    end
  end
end
