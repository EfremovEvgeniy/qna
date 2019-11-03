require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before :each do
      login_with user
    end
    let(:question) { create(:question, user: user) }
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before :each do
      login_with user
    end
    context 'for authenticated user' do
      before { get :new }

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context ' for unauthenticated user' do
      before :each do
        login_with nil
      end
      before { get :new }

      it 'redirects to login' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    before :each do
      login_with user
    end

    let(:unauth_user) { create(:user) }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect do
          post :create, params: {
            question: attributes_for(:question)
          }
        end .to change(user.questions, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to questions_path
      end

      it 'renders a flash message' do
        post :create, params: { question: attributes_for(:question) }
        expect(flash[:notice]).to eq 'Your question successfully created.'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: {
            question: attributes_for(:question, :invalid)
          }
        end .to_not change(Question, :count)
      end

      it 'redirects to new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context 'for unauthenticated user' do
      it 'does not create question' do
        expect do
          post :create, params: {
            question: attributes_for(:question, :invalid)
          }
        end .to_not change(Question, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      login_with user
    end
    before { question }

    context 'delete own question' do
      let(:question) { create(:question, user: user) }
      it "deletes user's own question" do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete not own question' do
      let(:random_user) { create(:user) }
      let!(:random_question) { create(:question, user: random_user) }

      it 'tries to delete not user\'s own questions' do
        expect { delete :destroy, params: { id: random_question } }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: random_question }
        expect(response).to redirect_to questions_path
      end
    end

    context ' for unauthenticated user' do
      before :each do
        login_with nil
      end
      let(:random_user) { create(:user) }
      let!(:random_question) { create(:question, user: random_user) }

      it 'tries to delete not user\'s own questions' do
        expect { delete :destroy, params: { id: random_question } }.to_not change(Question, :count)
      end
    end
  end
end
