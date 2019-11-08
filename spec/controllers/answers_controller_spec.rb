require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login_with(user) }
      it 'saves new, related to question answer in database' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question
          }, format: :js
        end .to change(question.answers, :count).by(1)
      end

      it 'is linked to user' do
        expect do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }, format: :js
        end .to change(user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'does not create answer' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question
          }
        end .to_not change(question.answers, :count)
      end

      it 'redirects to login page' do
        post :create, params: {
          answer: attributes_for(:answer),
          question_id: question
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid attributes' do
      before { login_with(user) }

      it 'does not save the question answer' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer, :invalid),
            question_id: question
          }, format: :js
        end .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:random_answer) { create(:answer, question: question) }

    context 'delete own answer' do
      before { login_with(user) }

      it 'deletes user\'s own answer' do
        expect do
          delete :destroy, params: {
            id: answer.id, question_id: question.id
          }
        end .to change(Answer, :count).by(-1)
      end

      it 'redirects to @answer.question show view' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'delete not own answer' do
      before { login_with(user) }

      it 'tries to delete not user\'s own answers' do
        expect do
          delete :destroy, params: {
            id: random_answer, question_id: question
          }
        end .to_not change(Answer, :count)
      end

      it 'redirects to random_answer.question show view' do
        delete :destroy, params: { id: random_answer, question_id: question }
        expect(response).to redirect_to question_path(random_answer.question)
      end
    end

    context ' for unauthenticated user' do
      it 'does not delete answer' do
        expect { delete :destroy, params: { id: random_answer } }.to_not change(Answer, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: random_answer }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login_with(user) }
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders template update' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login_with(user) }
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders template update' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'for unauthenticated user' do
      it 'does not update answer' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer, :body)
      end

      it 'returns 401 status' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
