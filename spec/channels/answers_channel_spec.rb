require 'rails_helper'

feature 'User can see in real time appearance of new answers', "
  As an user
  I'd like to be able see appearance of new users answers
" do
  given(:question) { create(:question) }

  describe 'new answer', js: true do
    background do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end
    end

    scenario 'appears on another user page' do
      Capybara.using_session('user') do
        fill_in 'Body', with: 'my awesome answer'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'my awesome answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'my awesome answer'
      end
    end

    scenario 'with errors does not appear on another user page' do
      Capybara.using_session('user') do
        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_css 'answers'
      end
    end
  end
end
