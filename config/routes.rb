# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'oauth_registrations' }

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me,  on: :collection
      end

      resources :questions, only: %i[index show create update destroy], shallow: true do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end

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
    resources :subscriptions, only: %i[create destroy], shallow: true
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
