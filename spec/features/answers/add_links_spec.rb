require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given!(:question) { create(:question) }
  given(:url) { 'https://thinknetica.teachbase.ru/' }
  given(:url_2) { 'https://github.com/EfremovEvgeniy' }

  describe 'Authenticated user adds', js: true do
    background do
      sign_in(question.user)
      visit question_path(question)
      fill_in 'Body', with: 'my awesome answer'
      fill_in 'Link name', with: 'My url'
      # fill_in 'Url', with: url
    end

    scenario 'link when answer question' do
      fill_in 'Url', with: url
      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My url', href: url
      end
    end

    scenario 'links when answer question' do
      fill_in 'Url', with: url
      click_on 'add more'
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My url 2'
        fill_in 'Url', with: url_2
      end
      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My url', href: url
        expect(page).to have_link 'My url 2', href: url_2
      end
    end

    scenario 'invalid link' do
      fill_in 'Url', with: 'invalid/link'
      click_on 'Create'

      expect(page).to have_no_link 'My url', href: 'invalid/link'
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
