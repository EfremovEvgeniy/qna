require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new, related to question answer in database' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question
          }
        end .to change(question.answers, :count).by(1)
      end

      it 'is linked to user' do
        expect do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }
        end .to change(@user.answers, :count).by(1)
      end

      it 'redirects to show question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question answer' do
        expect do
          post :create, params: {
            answer: attributes_for(:answer, :invalid),
            question_id: question
          }
        end .to_not change(Answer, :count)
      end

      it 'renders question show template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'delete own answer' do
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
      let(:random_user) { create(:user) }
      let!(:random_answer) { create(:answer, user: random_user, question: question) }

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
  end
end
