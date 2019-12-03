require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login_with(user) }

      context 'with valid attributes' do
        it 'saves a comment' do
          expect do
            post :create, params: { commentable: 'questions',
                                    user_id: user, question_id: question.id,
                                    comment: attributes_for(:comment), format: :js }
          end .to change(question.comments, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { commentable: 'questions',
                                  user_id: user, question_id: question.id,
                                  comment: attributes_for(:comment), format: :js }

          expect(response).to render_template :create
        end

        it 'created comment belongs to current user' do
          post :create, params: { commentable: 'questions',
                                  user_id: user, question_id: question.id,
                                  comment: attributes_for(:comment), format: :js }

          expect(assigns(:comment).user.id).to eq user.id
        end
      end

      context 'with invalid attributes' do
        it 'does not save comment' do
          expect do
            post :create, params: { commentable: 'questions',
                                    user_id: user, question_id: question.id,
                                    comment: attributes_for(:comment, :invalid_comment),
                                    format: :js }
          end .to_not change(question.comments, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save comment' do
        expect do
          post :create, params: { commentable: 'questions',
                                  user_id: user, question_id: question.id,
                                  comment: attributes_for(:comment, :invalid_comment),
                                  format: :js }
        end .to_not change(question.comments, :count)
      end

      it 'returns 401 status' do
        post :create, params: { commentable: 'questions',
                                user_id: user, question_id: question.id,
                                comment: attributes_for(:comment), format: :js }

        expect(response).to have_http_status 401
      end
    end
  end
end
