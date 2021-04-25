Rails.application.routes.draw do
  get 'achievements/index', to: 'achievements#index', as: :achievements
  devise_for :users
  root to: 'questions#index'
  concern :attachable do
    resources :attachments, only:[:destroy]
  end
  resources :questions, concerns: :attachable do
    patch 'mark_best/:answer_id', to: 'questions#mark_best', as: :mark_best
    resources :answers,  shallow: true do
      delete 'attachments/:id', to: 'attachments#destroy', as: :attachment
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
