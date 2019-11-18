require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:trophy) { create(:trophy, question: question) }
  let!(:answer) { create(:answer, question: question, user: user) }

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
        post :create, params:
        { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with link' do
      before { login_with(user) }
      it 'saves new, related to question answer in database' do
        expect do
          post :create, params: {
            question_id: question, answer: {
              body: 'MyBody',
              links_attributes: { '0' => { name: 'LinkName',
                                           url: 'https://www.linkexample.com/',
                                           _destroy: false } }
            }
          }, format: :js
        end .to change(question.answers, :count).by(1)
      end

      it 'is linked to user' do
        expect do
          post :create, params: {
            question_id: question, answer: {
              body: 'MyBody',
              links_attributes: { '0' => { name: 'LinkName',
                                           url: 'https://www.linkexample.com/',
                                           _destroy: false } }
            }
          }, format: :js
        end .to change(user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: {
          question_id: question, answer: {
            body: 'MyBody',
            links_attributes: { '0' => { name: 'LinkName',
                                         url: 'https://www.linkexample.com/',
                                         _destroy: false } }
          }
        }, format: :js
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
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, :invalid)
        }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:random_answer) { create(:answer, question: question) }

    context 'delete own answer' do
      before { login_with(user) }

      it 'deletes users own answer' do
        expect do
          delete :destroy, params: {
            id: answer.id, question_id: question.id
          }, format: :js
        end .to change(Answer, :count).by(-1)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'delete not own answer' do
      before { login_with(user) }

      it 'tries to delete not user\'s own answers' do
        expect do
          delete :destroy, params: {
            id: random_answer, question_id: question
          }, format: :js
        end .to_not change(Answer, :count)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: random_answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context ' for unauthenticated user' do
      it 'does not delete answer' do
        expect do
          delete :destroy, params:
         { id: random_answer },
                           format: :js
        end .to_not change(Answer, :count)
      end

      it 'returns 401 status' do
        delete :destroy, params: { id: random_answer }, format: :js
        expect(response).to have_http_status(401)
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

    context 'update additional attributes' do
      let!(:answer_with_link) { create(:answer) }
      let!(:link) { create(:link, linkable: answer_with_link) }

      before { login_with(answer_with_link.user) }
      it 'deletes link from answer' do
        patch :update, params: {
          id: answer_with_link, answer: {
            body: 'MyBody',
            links_attributes: { '0' => { name: link.name,
                                         url: link.url,
                                         _destroy: '1', id: link } }
          }
        }, format: :js
        answer_with_link.reload
        expect(answer_with_link.links.count).to be_zero
      end

      it 'renders template update' do
        patch :update, params: {
          id: answer_with_link, answer: {
            body: 'MyBody',
            links_attributes: { '0' => { name: link.name,
                                         url: link.url,
                                         _destroy: '1', id: link } }
          }
        }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login_with(user) }
      it 'does not change answer attributes' do
        expect do
          patch :update, params:
           { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer.reload, :body)
      end

      it 'renders template update' do
        patch :update, params:
         { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'for unauthenticated user' do
      it 'does not update answer' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer.reload, :body)
      end

      it 'returns 401 status' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to have_http_status(401)
      end
    end

    context 'not author answer' do
      let(:second_user) { create(:user) }
      before { login_with(second_user) }

      it 'tries to update not his own answer' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end .to_not change(answer.reload, :body)
      end

      it 'renders template update' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #make_best' do
    context 'only the by author question' do
      before { login_with(user) }

      it 'update answer attribute best' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'sets trophy to user' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        trophy.reload

        expect(answer.user).to eq trophy.user
      end

      it 'renders make_best view' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js

        expect(response).to render_template :make_best
      end
    end

    context 'not author question' do
      let(:second_user) { create(:user) }

      before { login_with(second_user) }

      it 'does not update answer attribute best' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end

      it 'renders make best temolate' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload

        expect(response).to render_template :make_best
      end
    end

    context 'for unauthenticated user' do
      it 'does not update answer attribute best' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end

      it 'returns 401 status' do
        patch :make_best, params: { id: answer, answer: { best: true } }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
