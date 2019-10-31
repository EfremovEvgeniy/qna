require 'rails_helper'

feature 'User can see list of  questions', "
  In order to acquainted with questions
  As an authenticated or unauthenticated user
  I'd like to be able to see list of questions
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  background { visit root_path }

  scenario 'Unauthenticated user can see list of questions' do
    expect(page).to have_content 'All questions'
    expect(page).to have_css('td#question_title', text: question.title)
    expect(page).to have_css('td#question_body', text: question.body)
    expect(page).to have_css('td#question_title', count: Question.all.count)
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can see list of questions' do
      expect(page).to have_content 'All questions'
      expect(page).to have_css('td#question_title', text: question.title)
      expect(page).to have_css('td#question_body', text: question.body)
      expect(page).to have_css('td#question_title', count: Question.all.count)
    end
  end
end
