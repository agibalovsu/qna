# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'oauth_registrations' }

  concern :likable do
    member do
      post :like_up, :like_down
      delete :revoke
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: %i[likable commentable] do
    resources :answers, concerns: %i[likable commentable], except: %i[index show], shallow: true do
      member do
        patch :best
      end
    end
  end

  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => '/cable'
end
