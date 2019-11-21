Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, only: %i[new create destroy update] do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  namespace :user do
    resources :trophies, only: :index
  end
end
