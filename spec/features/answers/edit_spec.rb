require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
  " do
  given(:second_user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'
    end

    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'Edit body', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_selector('textarea')
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Edit body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'with attached files', js: true do
      background do
        within '.answers' do
          fill_in 'Edit body', with: 'edited answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
          sleep(2)
        end
      end

      scenario 'edits his answer' do
        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'deletes any attached files' do
        within "#file_#{answer.files.second.id}" do
          expect(page).to have_link 'delete file'
        end
        within "#file_#{answer.files.first.id}" do
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
      visit question_path(answer.question)
    end

    scenario 'tries to edit not his own answer', js: true do
      expect(page).to have_no_link('Edit')
    end

    scenario 'tries to delete attached file from not his answer' do
      expect(page).to have_no_link('delete file')
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(answer.question)
    end

    scenario 'can not edit answer' do
      visit question_path(answer.question)

      expect(page).to have_no_link 'Edit'
    end

    scenario 'can not delete attached file' do
      expect(page).to have_no_link 'delete file'
    end
  end
end
