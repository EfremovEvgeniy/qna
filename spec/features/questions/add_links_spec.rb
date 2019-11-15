require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given!(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/EfremovEvgeniy/79dcd2444231b4269f06068fcd143fd0' }
  given(:gist_url_2) { 'https://gist.github.com/EfremovEvgeniy/f4ac4b60a3ab5afe34ce70c578143a9c' }

  describe 'User adds', js: true do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'link when asks question' do
      click_on 'Ask'

      expect(page).to have_content 'Test question'

      click_on 'show'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'links when asks question' do
      click_on 'add more'
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: gist_url_2
      end
      click_on 'Ask'

      expect(page).to have_content 'Test question'

      click_on 'show'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist 2', href: gist_url_2
    end
  end

  describe 'Author of question' do
    given!(:question_with_link) { create(:question_with_link) }
    background do
      sign_in(question_with_link.user)
      visit questions_path
    end

    scenario 'deletes link' do
      click_on 'edit'
      click_on 'delete link'
      visit questions_path(question_with_link)

      expect(page).to have_no_link 'MyLink'
    end
  end
end
