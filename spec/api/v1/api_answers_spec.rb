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
end
