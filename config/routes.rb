Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[new create destroy update] do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
end
