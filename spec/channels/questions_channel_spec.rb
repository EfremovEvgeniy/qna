require 'rails_helper'

feature 'User can see in real time appearance of new questions', "
  As an user
  I'd like to be able see appearance of new users questions
" do
  given(:user) { create(:user) }

  describe 'new question', js: true do
    background do
      in_browser(:one) do
        sign_in(user)
        visit questions_path
      end

      in_browser(:two) do
        visit questions_path
      end
    end

    scenario 'question appears on another user page' do
      in_browser(:one) do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Test question'
      end

      in_browser(:two) do
        expect(page).to have_content 'Test question'
      end
    end

    scenario 'question with errors does not appear on another user page' do
      in_browser(:one) do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        click_on 'Ask'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_no_content 'Test question'
      end

      in_browser(:two) do
        expect(page).to have_no_content 'Test question'
      end
    end
  end
end
