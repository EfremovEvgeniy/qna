require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }

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
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect do
          post :create, params: {
            question: attributes_for(:question)
          }
        end .to change(@user.questions, :count).by(1)
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
  end

  describe 'DELETE #destroy' do
    before { question }

    context 'delete own question' do
      it "deletes user's own question" do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete not own question' do
      before do
        @random_user = create(:user)
        @random_question = create(:question, user: @random_user)
      end

      it 'tries to delete not user\'s own questions' do
        expect { delete :destroy, params: { id: @random_question } }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: @random_question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
