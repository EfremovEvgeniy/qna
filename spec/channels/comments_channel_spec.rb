require 'rails_helper'

feature 'User can see in real time appearance of new comments', "
  As an user
  I'd like to be able see appearance of new users comments
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'new comment for question', js: true do
    background do
      in_browser(:one) do
        sign_in(user)
        visit question_path(question)
        click_on 'Add comment to that question'
      end

      in_browser(:two) do
        visit question_path(question)
      end
    end

    scenario 'appears on another user page' do
      in_browser(:one) do
        within "div#question_#{question.id}" do
          fill_in 'Body', with: 'my comment'
          click_on 'create comment'
        end

        expect(page).to have_content 'my comment'
      end

      in_browser(:two) do
        expect(page).to have_content 'my comment'
      end
    end

    scenario 'with errors does not appear on another user page' do
      within "div#question_#{question.id}" do
        click_on 'create comment'

        expect(page).to have_content "Body can't be blank"
      end

      in_browser(:two) do
        expect(page).to have_no_content 'my comment'
      end
    end
  end

  describe 'new comment for answer', js: true do
    background do
      in_browser(:one) do
        sign_in(user)
        visit question_path(question)
        click_on 'Add comment to that answer'
      end

      in_browser(:two) do
        visit question_path(question)
      end
    end

    scenario 'appears on another user page' do
      in_browser(:one) do
        within "div#answer_#{answer.id}" do
          fill_in 'Body', with: 'my comment'
          click_on 'create comment'
        end

        expect(page).to have_content 'my comment'
      end

      in_browser(:two) do
        expect(page).to have_content 'my comment'
      end
    end

    scenario 'with errors does not appear on another user page' do
      in_browser(:one) do
        within "div#answer_#{answer.id}" do
          click_on 'create comment'

          expect(page).to have_content "Body can't be blank"
        end
      end

      in_browser(:two) do
        expect(page).to have_no_content 'my comment'
      end
    end
  end
end
