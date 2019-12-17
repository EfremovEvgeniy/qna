require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    context 'unauthorazed' do
      it 'returns 401 if there is no access token' do
        get '/api/v1/questions', headers: headers

        expect(response.status).to eq 401
      end
      it 'returns 401 if access token invalid' do
        get '/api/v1/questions', params: { access_token: 'token' }, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorazed' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json.first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns array of questions' do
        expect(json.size).to eq 2
      end

      it 'returns all public fields' do
        %w[title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'aswers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns array of questions' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
