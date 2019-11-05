require 'rails_helper'

feature 'User on the question page can write answer', "
  In order to write my answer
  As an authenticated user
  I'd like to be able to write my answer on the question page
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'can write his answer' do
      visit question_path(question)
      expect(page).to have_field('Body')
      expect(page).to have_no_content('You need to sign in to write your answer')
      fill_in 'Body', with: 'my awesome answer'
      click_on 'Save'
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'my awesome answer'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)
    expect(page).to have_content 'You need to sign in to write your answer'
  end
end
