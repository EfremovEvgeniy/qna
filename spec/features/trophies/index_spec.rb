require 'rails_helper'

feature 'User can view a list of badges' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:second_question) { create(:question) }
  given!(:trophy) { create(:trophy, question: question, user: user) }
  given!(:second_trophy) { create(:trophy, question: second_question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      click_on 'My trophies'
    end

    scenario 'see list of trophies' do
      expect(page).to have_content trophy.name
      expect(page).to have_content trophy.question.title
      expect(page).to have_content second_trophy.name
      expect(page).to have_content second_trophy.question.title
    end
  end

  scenario 'Unauthenticated can not see trophies' do
    visit user_trophies_path
    expect(page).to_not have_selector('#trophies')
  end
end
