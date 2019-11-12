require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
  " do
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(question.user)
      visit root_path
      click_on 'edit'
    end

    scenario 'edits his own question' do
      fill_in 'Edit title', with: 'edited title'
      fill_in 'Edit body', with: 'edited body'
      click_on 'Save'

      expect(page).to have_no_content question.title
      expect(page).to have_no_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
      expect(page).to have_no_selector('textarea')
    end

    scenario 'edits his own question with errors' do
      fill_in 'Edit title', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
    end

    describe 'edits his own question with', js: true do
      background do
        fill_in 'Edit title', with: 'edited title'
        fill_in 'Edit body', with: 'edited body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
        click_on 'show'
      end

      scenario 'attaching files' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'deletes any attached file' do
        within "#file_#{question.files.second.id}" do
          expect(page).to have_link 'delete file'
        end
        within "#file_#{question.files.first.id}" do
          expect(page).to have_link 'delete file'
          click_on 'delete file'
        end

        expect(page).to have_no_link 'rails_helper.rb'
      end
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(second_user)
      visit root_path
    end

    scenario 'tries to edit not his own question', js: true do
      expect(page).to have_no_link('edit')
    end
  end

  scenario 'Unauthenticated user can not edit question' do
    visit root_path

    expect(page).to have_no_link 'edit'
  end
end
