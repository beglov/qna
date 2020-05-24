Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    member do
      delete :delete_file
    end
    resources :answers, shallow: true do
      member do
        post :select_best
        delete :delete_file
      end
    end
  end
end
