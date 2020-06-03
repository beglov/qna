Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    member do
      post :down
      post :up
      post :cancel_vote
    end
    resources :answers, shallow: true do
      member do
        post :select_best
        post :down
        post :up
        post :cancel_vote
      end
    end
  end
  resources :rewards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
