require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like Voted do
    let(:second_user) { create(:user) }
    let(:votable) { create(:question) }
  end

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
    before { login_with(user) }
    before { get :show, params: { id: question } }

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'for authenticated user' do
      before { login_with(user) }
      before { get :new }

      it 'assigns new @question.link' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context ' for unauthenticated user' do
      before { get :new }

      it 'redirects to login' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login_with(user) }
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

    context 'with link' do
      before { login_with(user) }
      it 'saves the new question in the database' do
        expect do
          post :create, params: {
            question: {
              title: 'MyTitle', body: 'MyBody',
              links_attributes: { '0' => { name: 'LinkName',
                                           url: 'https://www.linkexample.com/',
                                           _destroy: false } }
            }
          }
        end .to change(user.questions, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: {
          question: {
            title: 'MyTitle', body: 'MyBody',
            links_attributes: { '0' => { name: 'LinkName',
                                         url: 'https://www.linkexample.com/',
                                         _destroy: false } }
          }
        }
        expect(response).to redirect_to questions_path
      end

      it 'renders a flash message' do
        post :create, params: {
          question: {
            title: 'MyTitle', body: 'MyBody',
            links_attributes: { '0' => { name: 'LinkName',
                                         url: 'https://www.linkexample.com/',
                                         _destroy: false } }
          }
        }
        expect(flash[:notice]).to eq 'Your question successfully created.'
      end
    end

    context 'with invalid attributes' do
      before { login_with(user) }
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

    context 'with broadcasting' do
      before { login_with(user) }

      it 'broadcasts to question channel' do
        expect do
          post :create, params: {
            question: attributes_for(:question)
          }
        end .to have_broadcasted_to('questions_channel')
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

      it 'redirects to login page' do
        post :create, params: {
          question: attributes_for(:question, :invalid)
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:random_question) { create(:question) }

    context 'delete own question' do
      before { login_with(user) }
      let!(:question) { create(:question, user: user) }
      it "deletes user's own question" do
        expect do
          delete :destroy, params:
        { id: question }
        end .to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete not own question' do
      before { login_with(user) }

      it 'tries to delete not user\'s own questions' do
        expect do
          delete :destroy, params:
        { id: random_question }
        end .to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: random_question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'for unauthenticated user' do
      it 'tries to delete not user\'s own questions' do
        expect do
          delete :destroy, params:
        { id: random_question }
        end .to_not change(Question, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: random_question }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question_with_link) { create(:question) }
    let!(:link) { create(:link, linkable: question_with_link) }

    context 'with valid attributes' do
      before { login_with(user) }
      it 'changes question attributes' do
        patch :update, params:
        { id: question, question: { body: 'new body', title: 'new title' } }, format: :js
        question.reload
        expect(question.body).to eq 'new body'
        expect(question.title).to eq 'new title'
      end

      it 'renders template update' do
        patch :update, params:
        { id: question, question: { body: 'new body', title: 'new title' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'update additional attributes' do
      before { login_with(question_with_link.user) }
      it 'deletes link from question' do
        patch :update, params: {
          id: question_with_link, question: {
            title: question_with_link.title, body: question_with_link.body,
            links_attributes: {
              '0' => { name: link.name,
                       url: link.url,
                       _destroy: '1', id: link }
            }
          }
        }, format: :js
        question_with_link.reload

        expect(question_with_link.links.count).to be_zero
      end

      it 'renders template update' do
        patch :update, params: {
          id: question_with_link, question: {
            title: question_with_link.title, body: question_with_link.body,
            links_attributes: {
              '0' => { name: link.name,
                       url: link.url,
                       _destroy: '1', id: link }
            }
          }
        }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login_with(user) }
      it 'does not change question attributes' do
        expect do
          patch :update, params:
          { id: question, question: attributes_for(:question, :invalid) }, format: :js
          question.reload
        end.to_not change(question.reload, :title)
      end

      it 'renders template update' do
        patch :update, params:
        { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'for not author' do
      let(:second_user) { create(:user) }
      before { login_with(second_user) }

      it 'tries to update question' do
        expect do
          patch :update, params:
          { id: question, question: { body: 'new body', title: 'new title' } }, format: :js
        end.to_not change(question.reload, :title)
      end

      it 'renders template update' do
        patch :update, params:
        { id: question, question: { body: 'new body', title: 'new title' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'for unauthenticated user' do
      it 'does not update question' do
        expect do
          patch :update, params:
          { id: question, question: { body: 'new body', title: 'new title' } }, format: :js
        end.to_not change(question.reload, :title)
      end

      it 'returns 401 status' do
        patch :update, params:
        { id: question, question: { body: 'new body', title: 'new title' } }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
