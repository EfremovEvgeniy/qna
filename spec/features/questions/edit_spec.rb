require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
  " do
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link) { create(:link, linkable: question) }

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

    scenario 'edits his question with errors' do
      fill_in 'Edit title', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'adds link to question' do
      fill_in 'Edit title', with: 'edited title'
      fill_in 'Edit body', with: 'edited body'
      click_on 'add more'
      fill_in 'Link name', with: link.name
      fill_in 'Url', with: link.url
      click_on 'Save'
      visit question_path(question)

      expect(page).to have_link link.name, href: link.url
    end

    describe 'Author of question', js: true do
      scenario 'edits attached files' do
        fill_in 'Edit title', with: 'edited title'
        fill_in 'Edit body', with: 'edited body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_content 'edited title'

        visit question_path(question)

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Author of question', js: true do
    background do
      sign_in(question.user)
      question.files.attach(create_file_blob)
      visit question_path(question)
    end

    scenario 'deletes attached file' do
      expect(page).to have_link 'delete file'
      expect(page).to have_link 'image.jpg'

      click_on 'delete file'

      expect(page).to have_no_link 'image.jpg'
      expect(page).to have_no_link 'delete file'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(second_user)
    end

    scenario 'tries to edit not his own question' do
      visit root_path

      expect(page).to have_no_link('edit')
    end

    scenario 'tries to delete attached file from not his question' do
      visit question_path(question)

      expect(page).to have_no_link('delete file')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit question' do
      visit root_path

      expect(page).to have_no_link 'edit'
    end

    scenario 'can not delete attached file' do
      visit question_path(question)

      expect(page).to have_no_link 'delete file'
    end
  end
end
