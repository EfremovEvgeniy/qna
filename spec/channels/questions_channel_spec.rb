require 'rails_helper'

feature 'User can see in real time appearance of new questions', "
  As an user
  I'd like to be able see appearance of new users questions
" do
  given(:user) { create(:user) }

  scenario 'question appears on another user page', js: true do
    in_browser(:one) do
      sign_in(user)
      visit questions_path
    end

    in_browser(:two) do
      visit questions_path
    end

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
end
