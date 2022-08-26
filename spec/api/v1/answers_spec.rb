require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'response success'

      it 'returns list of questions' do
        expect(answers_response.size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end
end