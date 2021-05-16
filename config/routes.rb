Rails.application.routes.draw do
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only:[:index] do
        get :me, on: :collection
      end
      resources :questions, only:[:index, :show, :create, :update, :destroy] do
        resources :answers, only:[:index,:show,:create,:update]
      end
    end
  end
  get 'achievements/index', to: 'achievements#index', as: :achievements
  
  devise_for :users, controllers: {omniauth_callbacks: 'oauth_callbacks'}

  devise_scope :user do
    post 'email_confirmation', to: 'oauth_callbacks#confirm'
    get 'email_confirmed/:provider/:uid', to: 'oauth_callbacks#confirmed', as: :confirmed
  end
  root to: 'questions#index'
  
  concern :attachable do
    resources :attachments, only:[:destroy]
  end

  concern :votable do
    post 'rating/pro/:id', to: 'ratings#pro', as: :pro
    post 'rating/con/:id', to:'ratings#con', as: :con
  end
  resources :questions, concerns: [:attachable, :votable] do
    patch 'mark_best/:answer_id', to: 'questions#mark_best', as: :mark_best
    resources :comments, only:[:create], module: 'questions'
    resources :answers, concerns: :votable,  shallow: true do
      resources :comments, only:[:create], module: 'answers'
      delete 'attachments/:id', to: 'attachments#destroy', as: :attachment
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
