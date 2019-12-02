require 'rails_helper'

feature 'User can see in real time appearance of new questions', "
  As an user
  I'd like to be able see appearance of new users questions
" do
  given(:user) { create(:user) }

  describe 'new question', js: true do
    background do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end
    end

    scenario 'appears on another user page' do
      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Test question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_selector('div', id: "question_#{user.questions.first.id}")
        expect(page).to have_content 'Test question'
      end
    end

    scenario 'with errors does not appear on another user page' do
      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        click_on 'Ask'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_no_content 'Test question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_css '.questions'
      end
    end
  end
end
