require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  
  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'renders new view for answer' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in database' do
        expect{ post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(Answer, :count).by(1)
      end

    #   it 'redirects to show view' do
    #     post :create, params: { question: attributes_for(:question) }
    #     expect(response).to redirect_to assigns(:question)
    #   end
    # end

    # context 'with invalid attributes' do
    #   it 'does not save question' do
    #     expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
    #   end

    #   it 're-render new view' do
    #     post :create, params: { question: attributes_for(:question, :invalid) }
    #     expect(response).to render_template :new
    #   end
    end
  end
end
