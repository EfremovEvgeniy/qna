require 'rails_helper'

feature 'User can add comments to answer', "
  As anauthenticated user
  I'd like to be able to add comment
" do
  given!(:question) { create(:question_with_answer) }
  given!(:answer) { question.answers.first }
  given!(:user) { create(:user) }

  describe 'Authenticated user adds', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Add comment to that answer'
    end

    scenario 'comment to answer' do
      within "div#answer_#{answer.id}" do
        fill_in 'Body', with: 'my comment'
        click_on 'create comment'

        expect(page).to have_content 'my comment'
      end
    end

    scenario 'comment with empty body' do
      within "div#answer_#{answer.id}" do
        click_on 'create comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not add comment to answer' do
      expect(page).to have_no_content 'Add comment to that answer'
    end
  end
end
