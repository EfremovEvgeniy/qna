require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/EfremovEvgeniy/79dcd2444231b4269f06068fcd143fd0' }

  scenario 'User adds link when asks question', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: 'my awesome answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
