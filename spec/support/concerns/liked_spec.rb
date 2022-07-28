require 'rails_helper'

RSpec.shared_examples 'liked' do
  let(:liker) { create(:user) }
  let(:author) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  describe 'POST #vote_up' do
    context 'current user is not author of resource' do
      before { login(liker) }

      let!(:user_likable) { liked(model, author) }

      it 'try to add new like' do
        expect { post :vote_up, params: { id: user_likable } }.to change(Like, :count)
      end
    end

    context 'current user is author of resource' do
      before { login(author) }

      let!(:user_likable) { liked(model, author) }

      it 'can not add new like' do
        expect { post :vote_up, params: { id: user_likable } }.to_not change(Like, :count)
      end
    end

    describe 'POST #vote_down' do
      context 'current user is not author of resource' do
        before { login(liker) }

        let!(:user_likable) { liked(model, author) }

        it 'try to add new dislike' do
          expect { post :vote_down, params: { id: user_likable } }.to change(Like, :count)
        end
      end
    end

    context 'current user is author of resource' do
      before { login(author) }

      let!(:user_likable) { liked(model, author) }

      it 'can not add new dislike' do
        expect { post :vote_down, params: { id: user_likable } }.to_not change(Like, :count)
      end
    end

    describe 'DELETE #revoke' do
      context 'current user revoke his like' do
        before { login(liker) }

        let!(:user_likable) { liked(model, author) }

        it 'delete like' do
          post :vote_up, params: { id: user_likable }
          expect { delete :revoke, params: { id: user_likable } }.to change(Like, :count).by(-1)
        end
      end

      context 'current user' do
        let(:new_user) { create(:user) }
        let!(:new_like) { liked(model, new_user) }

        it 'try to revoke like of other user' do
          expect { delete :revoke, params: { id: new_like } }.to_not change(Like, :count)
        end
      end
    end
  end
end