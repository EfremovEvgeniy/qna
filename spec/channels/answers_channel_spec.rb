require 'rails_helper'

feature 'User can see in real time appearance of new answers', "
  As an user
  I'd like to be able see appearance of new users answers
" do
  given(:question) { create(:question) }

  describe 'new answer', js: true do
    background do
      in_browser(:one) do
        sign_in(question.user)
        visit question_path(question)
      end

      in_browser(:two) do
        visit question_path(question)
      end
    end

    scenario 'appears on another user page' do
      in_browser(:one) do
        fill_in 'Body', with: 'my awesome answer'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'my awesome answer'
        end
      end

      in_browser(:two) do
        expect(page).to have_content 'my awesome answer'
      end
    end

    scenario 'with errors does not appear on another user page' do
      in_browser(:one) do
        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
      end

      in_browser(:two) do
        within '.answers' do
          expect(page).to have_no_css 'answer'
        end
      end
    end
  end
end
