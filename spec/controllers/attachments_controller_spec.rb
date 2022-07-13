require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }

  describe 'DELETE #destroy' do
    before do
      login(author)
      attach_file_to(question)
      attach_file_to(answer)
    end

    context 'user an author' do

      it 'delete question attachment' do
        expect do
          delete :destroy,
                 params: { id: question.files.first }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end

      it 'delete answer attachment' do
        expect do
          delete :destroy,
                 params: { id: answer.files.first }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not an author' do
      before { login(user) }

      it 'delete the question attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'delete the answer attachment' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
