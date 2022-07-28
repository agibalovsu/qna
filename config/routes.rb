# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  
  concern :likable do
    member do
      post :like_up, :like_down
      delete :revoke
    end
  end

  resources :questions, concerns: :likable do
    resources :answers, concerns: :likable, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end

  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
end
