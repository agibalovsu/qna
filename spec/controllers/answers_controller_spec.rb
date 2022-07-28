# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves the new answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer), question_id: question, format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'assigns a current question to answer' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).question).to eq(question)
      end

      it 'assign created answer by current user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).user).to eq user
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        end.to_not change(question.answers, :count)
      end

      it 're-renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'with valid attributes' do
      before { login(author) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'user an author' do
      before { login(author) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not an author' do
      before { login(user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #best' do
    let(:author) { create(:user) }
    let(:answer_author) { create(:user) }
    let!(:new_question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: new_question, user: answer_author) }

    context 'user an author' do
      before { login(author) }
      before { patch :best, params: { id: answer, format: :js } }

      it 'assigns the request answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'render answer best' do
        expect(response).to render_template :best
      end
    end
  end
  it_behaves_like 'liked'
end
