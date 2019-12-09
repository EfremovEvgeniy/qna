Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post '/fill_email' => 'oauth_callbacks#fill_email'
  end

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers, concerns: :votable, shallow: true, only: %i[new create destroy update] do
      resources :comments, only: :create, defaults: { commentable: 'answers' }
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  namespace :user do
    resources :trophies, only: :index
  end
end
