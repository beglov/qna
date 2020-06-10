Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      post :down
      post :up
      post :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :select_best
      end
    end
  end
  resources :rewards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  mount ActionCable.server => '/cable'
end
