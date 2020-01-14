require 'sphinx_helper'

feature 'User can search', js: true, sphinx: true do
  given!(:user) { create(:user, email: 'test@gmail.com') }
  given!(:question) { create(:question, body: 'test') }
  given!(:answer) { create(:answer, body: 'test') }
  given!(:comment) { create(:comment, user: user, commentable: question, body: 'test') }

  SearchService::SCOPES.each do |search_scope|
    scenario "search in #{search_scope}" do
      ThinkingSphinx::Test.run do
        visit questions_path

        within '.search' do
          fill_in 'search_string', with: 'test*'
          select search_scope, from: 'search_scope'
          click_on 'Search'
        end

        within '.search_results' do
          expect(page).to have_content 'Search results:'
          expect(page).to have_content search_scope.singularize
        end
      end
    end
  end

  scenario 'search in all' do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_string', with: 'test'
        select 'All', from: 'search_scope'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.body)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end
    end
  end

  scenario 'empty search result' do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_string', with: 'smth'
        select 'All', from: 'search_scope'
        click_on 'Search'
      end

      expect(page).to have_content('Nothing was found.')
    end
  end
end
