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

      it_behaves_like 'providable public fields' do
        let(:fields_list) { %w[id body created_at updated_at] }
        let(:object) { answer }
        let(:object_response) { answer_response }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      include ControllerHelpers
      
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      before { 3.times { attach_file_to(answer) } }

      let(:object_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'response success'

      it_behaves_like 'providable public fields' do
        let(:fields_list) { %w[id body created_at updated_at] }
        let(:object) { answer }
        let(:object_response) { json['answer'] }
      end

      describe 'links' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id name url created_at updated_at] }
          let(:object)          { links.first }
          let(:object_response) { json['answer']['links'].first }
        end

        it 'returns list of links' do
          expect(json['answer']['links'].size).to eq 3
        end
      end

      describe 'comments' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id body created_at updated_at] }
          let(:object)          { comments.first }
          let(:object_response) { json['answer']['comments'].first }
        end

        it 'returns list of links' do
          expect(json['answer']['comments'].size).to eq 3
        end
      end
      
      it_behaves_like 'API files' do
        let(:item) { answer }
      end
    end
  end
end