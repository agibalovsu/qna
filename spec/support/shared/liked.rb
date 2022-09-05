# frozen_string_literal: true

shared_examples_for 'liked' do
  let(:liker) { create(:user) }
  let(:author) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  describe 'POST #like_up' do
    context 'current user is not author of resource' do
      before { login(liker) }

      let!(:user_likable) { liked(model, author) }

      it 'try to add new like' do
        expect { post :like_up, params: { id: user_likable }, format: :js }.to change(Like, :count)
      end
    end

    context 'current user is author of resource' do
      before { login(author) }

      let!(:user_likable) { liked(model, author) }

      it 'can not add new like' do
        expect { post :like_up, params: { id: user_likable }, format: :js }.to_not change(Like, :count)
      end
    end

    describe 'POST #like_down' do
      context 'current user is not author of resource' do
        before { login(liker) }

        let!(:user_likable) { liked(model, author) }

        it 'try to add new dislike' do
          expect { post :like_down, params: { id: user_likable }, format: :js }.to change(Like, :count)
        end
      end
    end

    context 'current user is author of resource' do
      before { login(author) }

      let!(:user_likable) { liked(model, author) }

      it 'can not add new dislike' do
        expect { post :like_down, params: { id: user_likable }, format: :js }.to_not change(Like, :count)
      end
    end

    describe 'DELETE #revoke' do
      context 'current user revoke his like' do
        before { login(liker) }

        let!(:user_likable) { liked(model, author) }

        it 'delete like' do
          post :like_up, params: { id: user_likable }
          expect { delete :revoke, params: { id: user_likable }, format: :js }.to change(Like, :count).by(-1)
        end
      end

      context 'current user' do
        let(:new_user) { create(:user) }
        let!(:new_like) { liked(model, new_user) }

        it 'try to revoke like of other user' do
          expect { delete :revoke, params: { id: new_like }, format: :js }.to_not change(Like, :count)
        end
      end
    end
  end
end
