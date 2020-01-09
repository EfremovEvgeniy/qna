require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:second_user) { create(:user) }

    context 'for authenticated user' do
      before { login_with(second_user) }

      it 'saves a new subscriber in the database' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(Subscriber, :count).by(1)
      end
    end

    context 'for unauthenticated user' do
      it 'does not save new subscriber' do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(Subscriber, :count)
      end

      it 'returns 401 status' do
        post :create, params: { question_id: question }, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      before { login_with(user) }

      it 'delete the subscriber' do
        expect { delete :destroy, params: { id: user.find_subscriber }, format: :js }.to change(Subscriber, :count).by(-1)
      end
    end

    context 'for unauthenticated user' do
      it 'does not delete subscriber' do
        expect { delete :destroy, params: { id: user.find_subscriber }, format: :js }.to_not change(Subscriber, :count)
      end

      it 'returns 401 status' do
        delete :destroy, params: { id: user.find_subscriber }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end
