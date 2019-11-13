require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:second_question) { create(:question) }

  describe 'DELETE #destroy' do
    context 'Authenticated and author of question' do
      before do
        login_with(question.user)
        question.files.attach(create_file_blob)
      end

      it 'delete your file from question' do
        expect do
          delete :destroy, params:
         { id: question.files[0] }, format: :js
        end .to change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        expect do
          delete :destroy, params:
         { id: question.files[0] }, format: :js
        end .to change(question.files, :count).by(-1)
      end
    end

    context 'Authenticated but not owner of question' do
      before do
        login_with(question.user)
        second_question.files.attach(create_file_blob)
      end

      it 'does not can delete file' do
        expect do
          delete :destroy, params:
         { id: second_question.files[0] }, format: :js
        end .not_to change(
          second_question.files, :count
        )
      end

      it 'renders destroy template' do
        expect do
          delete :destroy, params:
         { id: second_question.files[0] }, format: :js
        end .not_to change(
          second_question.files, :count
        )
        expect(response).to render_template :destroy
      end
    end

    context 'Unauthenticated user' do
      before { question.files.attach(create_file_blob) }

      it 'does not can delete file' do
        expect do
          delete :destroy, params:
         { id: question.files[0] }, format: :js
        end .not_to change(question.files, :count)
      end

      it 'returns 401 status' do
        expect do
          delete :destroy, params:
         { id: question.files[0] }, format: :js
        end .not_to change(question.files, :count)
        expect(response).to have_http_status(401)
      end
    end
  end
end
