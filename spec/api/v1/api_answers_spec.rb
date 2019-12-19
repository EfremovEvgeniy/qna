require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:link) { create(:link, linkable: answer) }
    let!(:comment) { create(:comment, commentable: answer, user: answer.user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorazed' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body user_id question_id created_at updated_at best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'links' do
        let(:links_response) { json['answer']['links'] }
        it 'returns array of links' do
          expect(links_response.size).to eq answer.links.size
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(links_response.first[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comments_response) { json['answer']['comments'] }
        it 'returns array of comments' do
          expect(comments_response.size).to eq answer.comments.size
        end
        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comments_response.first[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      # describe 'files' do
      #   let(:attachments_response) { json['answer']['files'] }
      #   it 'returns array of attachments' do
      #     expect(answer.files.size).to eq 1
      #     expect(attachments_response.size).to eq answer.files.size
      #   end

      #   it 'return link to file' do
      #     expect(response.body).to include_json(answer.files.first.filename.to_s.to_json)
      #   end
      # end
    end
  end

  describe 'POST api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post api_path, params: { question_id: question.id, action: :create, format: :json,
                                 answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post api_path, params: { question_id: question.id, action: :create,
                                 access_token: '1234', format: :json,
                                 answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      context 'creates with valid atrributes' do
        it 'creates answer' do
          expect do
            post api_path, params: { question_id: question.id, action: :create, format: :json,
                                     access_token: access_token.token,
                                     answer: attributes_for(:answer) }
          end .to change(Answer, :count).by(1)
        end

        it 'creates answer with link' do
          expect do
            post api_path, params: { action: :create, format: :json, access_token: access_token.token,
                                     question_id: question, answer: { body: 'MyBody',
                                                                      links_attributes: {
                                                                        '0' => { name: 'LinkName',
                                                                                 url: 'https://www.linkexample.com/',
                                                                                 _destroy: false }
                                                                      } } }
          end .to change(Answer, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create answer' do
          expect do
            post api_path, params: { question_id: question.id, action: :create, format: :json,
                                     access_token: access_token.token,
                                     answer: attributes_for(:answer, :invalid) }
          end .to_not change(Answer, :count)
        end

        it 'returns error status' do
          post api_path, params: { question_id: question.id, action: :create, format: :json,
                                   access_token: access_token.token,
                                   answer: attributes_for(:answer, :invalid) }
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    context 'unauthorized' do
      let(:access_token) { create(:access_token) }
      it 'returns 401 status if there is no access_token' do
        patch api_path, params: { action: :update, format: :json, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch api_path, params: { action: :update, access_token: '1234', format: :json,
                                  answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if user not author' do
        patch api_path, params: { action: :update, access_token: access_token, format: :json,
                                  answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      context 'with valid atrributes' do
        let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
        let!(:link) { create(:link, linkable: answer) }

        it 'updates answer' do
          patch api_path, params: { id: answer.id, action: :update, format: :json, access_token: access_token.token,
                                    answer: { body: 'new body' } }
          expect(answer.reload.body).to eq 'new body'
        end

        it 'deletes link from answer' do
          patch api_path, params: { action: :update, format: :json, access_token: access_token.token,
                                    id: answer.id, answer: {
                                      body: 'MyBody',
                                      links_attributes: { '0' => { name: link.name,
                                                                   url: link.url,
                                                                   _destroy: '1', id: link.id } }
                                    } }
          expect(answer.reload.links.count).to be_zero
        end
      end

      context 'with invalid attributes' do
        it 'does not update answer attributes' do
          expect do
            patch api_path, params: { action: :update, format: :json, access_token: access_token.token,
                                      answer: attributes_for(:answer, :invalid) }
          end .to_not change(answer.reload, :body)
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    context 'unauthorized' do
      let(:access_token) { create(:access_token) }
      it 'returns 401 status if there is no access_token' do
        delete api_path, params: { action: :destroy, format: :json, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete api_path, params: { action: :destroy, access_token: '1234', format: :json,
                                   answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if user not author' do
        patch api_path, params: { action: :update, access_token: access_token, format: :json,
                                  answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'deletes answer' do
        expect do
          delete api_path, params: { action: :destroy, format: :json, access_token: access_token.token,
                                     answer: answer.id }
        end.to change(Answer, :count).by(-1)
      end
    end
  end
end
