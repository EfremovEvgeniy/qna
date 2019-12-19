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

      it_behaves_like 'Successful response'

      it 'returns all public fields' do
        %w[id body user_id question_id created_at updated_at best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'links' do
        let(:links_response) { json['answer']['links'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { links_response }
          let(:count) { answer.links.size }
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(links_response.first[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comments_response) { json['answer']['comments'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { comments_response }
          let(:count) { answer.comments.size }
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comments_response.first[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:attachments_response) { json['answer']['files'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { attachments_response }
          let(:count) { answer.files.size }
        end

        it 'return link to file' do
          expect(response.body).to include_json(answer.files.first.filename.to_s.to_json)
        end
      end
    end
  end

  describe 'POST api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable with attributes' do
      let(:method) { :post }
      let(:factory) { :answer }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer) { create(:answer) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Creatable object' do
        let(:object) { create(:answer) }
        let(:method) { :post }
        let(:valid_attributes) do
          { params: { question_id: question.id, action: :create, format: :json,
                      access_token: access_token.token,
                      answer: attributes_for(:answer) } }
        end
        let(:valid_attributes_with_link) do
          { params: { action: :create, format: :json, access_token: access_token.token,
                      question_id: question, answer: { body: 'MyBody',
                                                       links_attributes: {
                                                         '0' => { name: 'LinkName',
                                                                  url: 'https://www.linkexample.com/',
                                                                  _destroy: false }
                                                       } } } }
        end
        let(:invalid_attributes) do
          { params: { question_id: question.id, action: :create, format: :json,
                      access_token: access_token.token,
                      answer: attributes_for(:answer, :invalid) } }
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable with attributes' do
      let(:method) { :patch }
      let(:factory) { :answer }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Updatable object' do
        let(:method) { :patch }
        let(:object) { answer }
        let(:valid_attributes) do
          { params: { action: :update, format: :json, access_token: access_token.token,
                      answer: { body: 'new body' } } }
        end
        let(:valid_attributes_with_link) do
          { params: { action: :update, format: :json, access_token: access_token.token,
                      answer: {
                        body: 'MyBody',
                        links_attributes: { '0' => { name: link.name,
                                                     url: link.url,
                                                     _destroy: '1', id: link.id } }
                      } } }
        end
        let(:invalid_attributes) do
          { params: { action: :update, format: :json, access_token: access_token.token,
                      answer: attributes_for(:answer, :invalid) } }
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable with attributes' do
      let(:method) { :delete }
      let(:factory) { :answer }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'
      it_behaves_like 'Deletable object' do
        let(:object) { answer }
      end
    end
  end
end
