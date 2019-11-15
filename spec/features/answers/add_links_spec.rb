require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/EfremovEvgeniy/79dcd2444231b4269f06068fcd143fd0' }
  given(:gist_url_2) { 'https://gist.github.com/EfremovEvgeniy/f4ac4b60a3ab5afe34ce70c578143a9c' }

  describe 'User adds', js: true do
    background do
      sign_in(question.user)
      visit question_path(question)
      fill_in 'Body', with: 'my awesome answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'link when answer question' do
      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'links when answer question' do
      click_on 'add more'
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: gist_url_2
      end
      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist 2', href: gist_url_2
      end
    end
  end
end
