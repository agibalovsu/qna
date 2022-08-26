require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:questions) { create_list(:question, 3, user: user) }
  let(:question) { questions.first }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'response success'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end
end
