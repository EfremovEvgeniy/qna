require 'rails_helper'

feature 'User can make a best one of the answers of his question', "
  In order to choose usefull answer
  As an author of question
  I'd like to be able to mark one of the answers like a best
" do
  given!(:question) { create(:question) }
  given!(:second_user) { create(:user) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(second_user)
      visit question_path(question)
    end

    scenario 'is not author of question' do
      expect(page).to have_no_link 'Best answer'
    end
  end

  describe 'User is a author of question', js: true do
    background do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'he marks best answer' do
      expect(page).to have_link 'Best answer'

      within "#answer_#{answers.first.id}" do
        click_on 'Best answer'

        expect(page).to have_content 'You marked this answer like best!'
      end
    end

    scenario 'best answer must be first in the list' do
      expect(page).to have_no_content 'You marked this answer like best!'

      within "#answer_#{answers.first.id}" do
        click_on 'Best answer'
      end

      within '.answers' do
        expect(page.find('.answer', match: :first)).to have_content 'You marked this answer like best!'
      end
    end

    scenario 'best answer may be only one' do
      within "#answer_#{answers.first.id}" do
        click_on 'Best answer'

        expect(page).to have_content 'You marked this answer like best!'
      end

      within "#answer_#{answers.second.id}" do
        click_on 'Best answer'

        expect(page).to have_content 'You marked this answer like best!'
      end

      within "#answer_#{answers.first.id}" do
        expect(page).to have_no_content 'You marked this answer like best!'
      end

      within "#answer_#{answers.third.id}" do
        expect(page).to have_no_content 'You marked this answer like best!'
      end
    end
  end
end
