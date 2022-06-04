# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'saves the new answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer), question_id: question }
        end.to change(question.answers, :count).by(1)
      end

      it 'assigns a current question to answer' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).question).to eq(question)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: question }
        end.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end
end
