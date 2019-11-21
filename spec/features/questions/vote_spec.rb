require 'rails_helper'

feature 'User can give vote to question', "
  As an authenticated user and not author of question
  I'd like to be able to give vote to question
" do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:third_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    describe 'vote' do
      background do
        sign_in second_user
        visit questions_path
      end

      scenario 'up and up' do
        click_on 'up'

        expect(page).to have_content 'Total votes:1'

        in_browser(:two) do
          sign_in third_user
          visit questions_path
          click_on 'up'

          expect(page).to have_content 'Total votes:2'
        end
      end

      scenario 'down and up' do
        click_on 'down'

        expect(page).to have_content 'Total votes:-1'

        in_browser(:two) do
          sign_in third_user
          visit questions_path
          click_on 'up'

          expect(page).to have_content 'Total votes:0'
        end
      end

      scenario 'down and down' do
        click_on 'down'

        expect(page).to have_content 'Total votes:-1'

        in_browser(:two) do
          sign_in third_user
          visit questions_path
          click_on 'down'

          expect(page).to have_content 'Total votes:-2'
        end
      end

      scenario 'can give only one vote' do
        click_on 'up'

        expect(page).to have_content 'Total votes:1'

        click_on 'up'

        expect(page).to have_content 'Total votes:1'
      end
    end

    scenario 'Author question cannot vote' do
      sign_in user
      visit questions_path

      expect(page).to_not have_selector(:button, 'up')
      expect(page).to_not have_selector(:button, 'down')
    end

    describe 'Unauthenticated user' do
      scenario 'can not vote' do
        visit questions_path

        expect(page).to_not have_selector(:button, 'up')
        expect(page).to_not have_selector(:button, 'down')
      end
    end
  end
end
