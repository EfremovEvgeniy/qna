require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
  " do
  given(:second_user) { create(:user) }
  given!(:answer) { create(:answer) }
  given(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'
    end

    scenario 'edits his own answer' do
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

    scenario 'adds link to answer' do
      within '.answers' do
        fill_in 'Edit body', with: 'edited answer'
        click_on 'add more'
        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url
        click_on 'Save'

        expect(page).to have_link link.name, href: link.url
      end
    end

    describe 'edits his own answer with', js: true do
      background do
        within '.answers' do
          fill_in 'Edit body', with: 'edited answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
      end

      scenario 'attaching files' do
        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
  end

  describe 'Author of answer', js: true do
    background do
      sign_in(answer.user)
      answer.files.attach(create_file_blob)
      visit question_path(answer.question)
    end

    scenario 'deletes attached file' do
      expect(page).to have_link 'delete file'
      expect(page).to have_link 'image.jpg'

      click_on 'delete file'

      expect(page).to have_no_link 'image.jpg'
      expect(page).to have_no_link 'delete file'
    end
  end

  describe 'Author of answer', js: true do
    given!(:link) { create(:link, linkable: answer) }
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    scenario 'deletes link' do
      click_on 'Edit'
      within all('.nested-fields')[0] do
        click_on 'delete link'
      end
      click_on 'Save'

      expect(page).to have_no_link link.name
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
