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
      Capybara.using_session('first_user') do
        sign_in(user)
        visit question_path(question)
        expect(page).to have_no_content 'my comment'
        click_on 'Add comment to that question'
      end

      Capybara.using_session('second_user') do
        visit question_path(question)
        expect(page).to have_no_content 'my comment'
      end
    end

    scenario 'appears on another user page' do
      Capybara.using_session('first_user') do
        within "div#question_#{question.id}" do
          fill_in 'Body', with: 'my comment'
          click_on 'create comment'
        end

        expect(page).to have_content 'my comment'
      end

      Capybara.using_session('second_user') do
        expect(page).to have_selector('div', id: "comment_#{question.comments.first.id}")
        expect(page).to have_content 'my comment'
      end
    end

    scenario 'with errors does not appear on another user page' do
      Capybara.using_session('first_user') do
        within "div#question_#{question.id}" do
          click_on 'create comment'

          expect(page).to have_content "Body can't be blank"
        end
      end

      Capybara.using_session('second_user') do
        within "div#comments_question_#{question.id}" do
          expect(page).to have_no_selector('div', id: /comment_*/)
        end
      end
    end
  end

  describe 'new comment for answer', js: true do
    background do
      Capybara.using_session('first_user') do
        sign_in(user)
        visit question_path(question)
        expect(page).to have_no_content 'my comment'
        click_on 'Add comment to that answer'
      end

      Capybara.using_session('second_user') do
        visit question_path(question)
        expect(page).to have_no_content 'my comment'
      end
    end

    scenario 'appears on another user page' do
      Capybara.using_session('first_user') do
        within "div#answer_#{answer.id}" do
          fill_in 'Body', with: 'my comment'
          click_on 'create comment'
        end

        expect(page).to have_content 'my comment'
      end

      Capybara.using_session('second_user') do
        expect(page).to have_selector('div', id: "comment_#{answer.comments.first.id}")
        expect(page).to have_content 'my comment'
      end
    end

    scenario 'with errors does not appear on another user page' do
      Capybara.using_session('first_user') do
        within "div#answer_#{answer.id}" do
          click_on 'create comment'

          expect(page).to have_content "Body can't be blank"
        end
      end

      Capybara.using_session('second_user') do
        within "div#comments_answer_#{answer.id}" do
          expect(page).to have_no_selector('div', id: /comment_*/)
        end
      end
    end
  end
end
