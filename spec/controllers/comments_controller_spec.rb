require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create to question' do
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

        it 'broadcasts to comment channel' do
          expect do
            post :create, params: { commentable: 'questions',
                                    user_id: user, question_id: question.id,
                                    comment: attributes_for(:comment), format: :js }
          end .to have_broadcasted_to("questions/#{question.id}/comments")
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

  describe 'POST #create to answer' do
    context 'authenticated user' do
      before { login_with(user) }

      context 'with valid attributes' do
        it 'saves a comment' do
          expect do
            post :create, params: { commentable: 'answers',
                                    user_id: user, answer_id: answer.id,
                                    comment: attributes_for(:comment), format: :js }
          end .to change(answer.comments, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { commentable: 'answers',
                                  user_id: user, answer_id: answer.id,
                                  comment: attributes_for(:comment), format: :js }

          expect(response).to render_template :create
        end

        it 'created comment belongs to current user' do
          post :create, params: { commentable: 'answers',
                                  user_id: user, answer_id: answer.id,
                                  comment: attributes_for(:comment), format: :js }

          expect(assigns(:comment).user.id).to eq user.id
        end

        it 'broadcasts to comment channel' do
          expect do
            post :create, params: { commentable: 'answers',
                                    user_id: user, answer_id: answer.id,
                                    comment: attributes_for(:comment), format: :js }
          end .to have_broadcasted_to("questions/#{answer.question.id}/comments")
        end
      end

      context 'with invalid attributes' do
        it 'does not save comment' do
          expect do
            post :create, params: { commentable: 'answers',
                                    user_id: user, answer_id: answer.id,
                                    comment: attributes_for(:comment, :invalid_comment),
                                    format: :js }
          end .to_not change(answer.comments, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save comment' do
        expect do
          post :create, params: { commentable: 'answers',
                                  user_id: user, answer_id: answer.id,
                                  comment: attributes_for(:comment, :invalid_comment),
                                  format: :js }
        end .to_not change(answer.comments, :count)
      end

      it 'returns 401 status' do
        post :create, params: { commentable: 'answers',
                                user_id: user, answer_id: answer.id,
                                comment: attributes_for(:comment), format: :js }

        expect(response).to have_http_status 401
      end
    end
  end
end
