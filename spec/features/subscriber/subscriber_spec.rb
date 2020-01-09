require 'rails_helper'

feature 'User can subscibers to question', js: true do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }

  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    describe 'Author question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      context 'author question already subscribed for your question' do
        it 'already subscribe' do
          expect(page).to have_button('unsubscribe!')
        end
      end

      context 'author can unsubscribe for your question' do
        it 'unsubscribers' do
          click_on 'unsubscribe!'

          expect(page).to have_button('subscribe!')
        end
      end
    end

    describe 'Any user subscribe and unsubscribe to question' do
      given(:third_user) { create(:user) }
      given!(:subscriber) { create(:subscriber, user: third_user, question: question) }

      it 'subscribers' do
        sign_in(second_user)
        visit question_path(question)
        click_on 'subscribe!'

        expect(page).to have_button('unsubscribe!')
      end

      it 'unsubscribers' do
        sign_in(third_user)
        visit question_path(question)
        click_on 'unsubscribe!'

        expect(page).to have_button('subscribe!')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not subscribers' do
      visit question_path(question)

      expect(page).to_not have_content 'subscribe!'
    end
  end
end
