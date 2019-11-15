require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given!(:user) { create(:user) }
  given(:url) { 'https://thinknetica.teachbase.ru/' }
  given(:url_2) { 'https://github.com/EfremovEvgeniy' }

  describe 'Authenticated user adds', js: true do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My url'
    end

    scenario 'link when asks question' do
      fill_in 'Url', with: url
      click_on 'Ask'

      expect(page).to have_content 'Test question'

      click_on 'show'

      expect(page).to have_link 'My url', href: url
    end

    scenario 'links when asks question' do
      fill_in 'Url', with: url
      click_on 'add more'
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My url 2'
        fill_in 'Url', with: url_2
      end
      click_on 'Ask'

      expect(page).to have_content 'Test question'

      click_on 'show'

      expect(page).to have_link 'My url', href: url
      expect(page).to have_link 'My url 2', href: url_2
    end

    scenario 'invalid link' do
      fill_in 'Url', with: 'invalid/link'
      click_on 'Ask'

      expect(page).to have_no_link 'My url', href: 'invalid/link'
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
