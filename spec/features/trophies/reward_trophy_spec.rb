require 'rails_helper'

feature 'When user choose best answer his reward answers author', "
  In order to reward author of best answer
  As an question's author
  I'd like to be able to have autoreward option for best answer
" do
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:trophy) { create(:trophy, question: question) }
  given!(:answer) { create(:answer, question: question, user: second_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'choose best answer and reward author' do
      click_on 'Best answer'
      click_on 'Log out'
      sign_in(second_user)
      click_on 'My trophies'

      expect(page).to have_content trophy.name
    end
  end
end
