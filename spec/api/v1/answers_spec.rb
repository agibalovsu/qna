# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

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

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          post api_path,
               params: { answer: attributes_for(:answer), question_id: question, access_token: access_token.token }
        end

        it 'save new answer' do
          expect { send_request }.to change(Answer, :count).by(1)
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end

        it 'answer has assocation with user' do
          send_request
          expect(Answer.last.user_id).to eq access_token.resource_owner_id
        end
      end
      context 'with invalid attributes' do
        let(:send_bad_request) do
          post api_path,
               params: { answer: attributes_for(:answer, :invalid), question_id: question,
                         access_token: access_token.token }
        end

        it 'does not save question' do
          expect { send_bad_request }.to_not change(Answer, :count)
        end

        it 'does not create answer' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          patch api_path,
                params: { id: answer, answer: { body: 'new body' }, question_id: question,
                          access_token: access_token.token }
        end

        it 'assigns the requested question to @question' do
          send_request
          expect(assigns(:answer)).to eq answer
        end

        it 'changes question attributes' do
          send_request
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        context 'with valid attributes' do
          let(:send_bad_request) do
            patch api_path,
                  params: { answer: attributes_for(:answer, :invalid), question_id: question,
                            access_token: access_token.token }
          end

          it 'does not update answer' do
            body = answer.body
            send_bad_request
            answer.reload

            expect(answer.body).to eq body
          end

          it 'does not create answer' do
            send_bad_request
            expect(response.status).to eq 422
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          delete api_path, params: { id: answer, question_id: question, access_token: access_token.token }
        end

        it 'delete the answer' do
          expect { send_request }.to change(Answer, :count).by(-1)
        end
        it 'status success' do
          send_request
          expect(response.status).to eq 204
        end
      end
    end
  end
end
