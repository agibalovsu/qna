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

      it_behaves_like 'providable public fields' do
        let(:fields_list) { %w[id title body created_at updated_at] }
        let(:object) { question }
        let(:object_response) { question_response }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      include ControllerHelpers
      
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      before { 3.times { attach_file_to(question) } }

      let(:object_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'response success'

      it_behaves_like 'providable public fields' do
        let(:fields_list) { %w[id title body created_at updated_at] }
        let(:object) { question }
        let(:object_response) { json['question'] }
      end

      it_behaves_like 'API links' do
        let(:item) { question }
      end

      describe 'comments' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id body created_at updated_at] }
          let(:object)          { comments.first }
          let(:object_response) { json['question']['comments'].first }
        end

        it 'returns list of links' do
          expect(json['question']['comments'].size).to eq 3
        end
      end

      it_behaves_like 'API files' do
        let(:item) { question }
      end
    end
  end

end