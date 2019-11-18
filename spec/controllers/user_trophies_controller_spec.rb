require 'rails_helper'

RSpec.describe User::TrophiesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:trophies) { create_list :trophy, 3, question: question, user: user }

  describe 'GET #index' do
    context 'for authenticated user' do
      before { login_with(user) }

      before { get :index }

      it 'populates an array of all questions' do
        expect(assigns(:trophies)).to match_array(trophies)
      end

      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    context 'for authenticated user' do
      before { get :index }

      it 'redirects to login path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
