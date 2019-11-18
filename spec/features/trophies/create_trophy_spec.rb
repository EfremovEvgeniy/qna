require 'rails_helper'

feature 'User can add trophy to new question', "
  In order to reward author of best answer
  As an question's author
  I'd like to be able to add trophy when create my question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      within '.trophy' do
        fill_in 'question[trophy_attributes][name]', with: 'Your trophy!'
      end
    end

    scenario 'add trophy to his new question' do
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'

      click_on 'show'

      expect(page).to have_content 'text text text'
      within '.trophy' do
        expect(page).to have_content 'Your trophy!'
      end
    end

    scenario 'add trophy with image' do
      within '.trophy' do
        attach_file 'question[trophy_attributes][image]', "#{Rails.root}/spec/fixtures/files/image.jpg"
      end
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'text text text'

      click_on 'show'

      within '.trophy' do
        expect(page).to have_content 'Your trophy!'
        expect(page).to have_css('img')
      end
    end
  end
end
