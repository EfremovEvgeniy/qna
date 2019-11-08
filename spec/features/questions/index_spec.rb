require 'rails_helper'

feature 'User can see list of  questions', "
  In order to acquainted with questions
  As an authenticated or unauthenticated user
  I'd like to be able to see list of questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5) }
  background { visit root_path }

  scenario 'Unauthenticated user can see list of questions' do
    within '.questions' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can see list of questions' do
      within '.questions' do
        questions.each do |question|
          expect(page).to have_content question.title
        end
      end
    end
  end
end
