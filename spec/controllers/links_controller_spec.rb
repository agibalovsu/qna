require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:link_q) { create(:link, linkable: question) }
  let!(:link_a) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    before { login(author) }

    context 'user an author' do

      it 'delete question link' do
        expect do
          delete :destroy,
                 params: { id: link_q.id }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: link_q }, format: :js
        expect(response).to render_template :destroy
      end

      it 'delete answer link' do
        expect do
          delete :destroy,
                 params: { id: link_a }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 're-render question show' do
        delete :destroy, params: { id: link_a }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not an author' do
      before { login(user) }

      it 'delete the question link' do
        expect { delete :destroy, params: { id: link_q }, format: :js }.to_not change(Link, :count)
      end

      it 'delete the answer link' do
        expect { delete :destroy, params: { id: link_a }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
