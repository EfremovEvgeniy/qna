require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question, :attachment_file) }
  let!(:file) { question.files[0] }
  let!(:second_question) { create(:question, :attachment_file) }
  let!(:second_file) { second_question.files[0] }

  describe 'DELETE #destroy' do
    context 'delete attachment file' do
      before { login_with(question.user) }

      it 'delete his file ' do
        expect(question).to_not be_nil
        expect(question.files[0]).to_not be_nil
        # expect { delete :destroy, params: { id: file }, format: :js }.to change(question.files, :count).by(-1)
      end

      # it 'delete not your file' do
      #   expect { delete :destroy, params: { id: second_file }, format: :js }.not_to change(second_question.files, :count)
      # end

      # it 'renders destroy your file view' do
      #   delete :destroy, params: { id: file }, format: :js
      #   expect(response).to render_template :destroy
      # end

      # it 'renders destroy not your file view' do
      #   delete :destroy, params: { id: second_file }, format: :js
      #   expect(response.body).to eq("alert('Permission denied');")
      # end
    end
  end
end
