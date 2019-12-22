require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorazed' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Returns list of objects' do
        let(:given_response) { json['questions'] }
        let(:count) { 2 }
      end

      it 'returns all public fields' do
        %w[title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'aswers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { question_response['answers'] }
          let(:count) { 3 }
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorazed' do
      let(:access_token) { create(:access_token) }
      let!(:question_answers) { create_list(:answer, 3, question: question) }
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Returns list of objects' do
        let(:given_response) { json['answers'] }
        let(:count) { 3 }
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let!(:link) { create(:link, linkable: question) }
    let!(:comment) { create(:comment, commentable: question, user: question.user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorazed' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'links' do
        let(:links_response) { json['question']['links'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { links_response }
          let(:count) { question.links.size }
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(links_response.first[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comments_response) { json['question']['comments'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { comments_response }
          let(:count) { question.comments.size }
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comments_response.first[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:attachments_response) { json['question']['files'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { attachments_response }
          let(:count) { question.files.size }
        end

        it 'return link to file' do
          expect(response.body).to include_json(question.files.first.filename.to_s.to_json)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable with attributes' do
      let(:method) { :post }
      let(:factory) { :question }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Creatable object' do
        let(:object) { create(:question) }
        let(:method) { :post }
        let(:valid_attributes) do
          { params: { action: :create, format: :json, access_token: access_token.token,
                      question: attributes_for(:question) } }
        end
        let(:valid_attributes_with_link) do
          { params: { action: :create, format: :json, access_token: access_token.token,
                      question: {
                        title: 'MyTitle', body: 'MyBody',
                        links_attributes: { '0' => { name: 'LinkName',
                                                     url: 'https://www.linkexample.com/',
                                                     _destroy: false } }
                      } } }
        end
        let(:invalid_attributes) do
          { params: { action: :create, format: :json, access_token: access_token.token,
                      question: attributes_for(:question, :invalid) } }
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable with attributes' do
      let(:method) { :patch }
      let(:factory) { :question }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
      let(:link) { create(:link, linkable: question) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Updatable object' do
        let(:method) { :patch }
        let(:object) { question }
        let(:valid_attributes) do
          { params: { action: :update, format: :json, access_token: access_token.token,
                      question: { body: 'new body', title: 'new title' } } }
        end
        let(:valid_attributes_with_link) do
          { params: { action: :update, format: :json, access_token: access_token.token,
                      question: {
                        title: 'MyTitle', body: 'MyBody',
                        links_attributes: { '0' => { name: link.name,
                                                     url: link.url,
                                                     _destroy: '1', id: link.id } }
                      } } }
        end
        let(:invalid_attributes) do
          { params: { action: :update, format: :json, access_token: access_token.token,
                      question: attributes_for(:question, :invalid) } }
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable with attributes' do
      let(:method) { :delete }
      let(:factory) { :question }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'
      it_behaves_like 'Deletable object' do
        let(:object) { question }
      end
    end
  end
end
