require 'rails_helper'

feature 'User on the question page can write answer', "
  In order to write my answer
  As an authenticated user
  I'd like to be able to write my answer on the question page
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create his answer' do
      expect(page).to have_field('Body')

      fill_in 'Body', with: 'my awesome answer'
      click_on 'Create'

      within '.answers' do
        expect(page).to have_content 'my awesome answer'
      end
    end

    scenario 'can create answer with attached file' do
      fill_in 'Body', with: 'my awesome answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'creates answer with errors' do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in to write your answer'
  end
end
