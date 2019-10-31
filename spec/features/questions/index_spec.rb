require 'rails_helper'

feature 'User can see list of  questions', "
  In order to acquainted with questions 
  As an authenticated or unauthenticated user
  I'd like to be able to see list of questions
" do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user can see list of questions' do
    visit root_path
  
    expect(page).to have_content 'All questions'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

end