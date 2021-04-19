Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions do
    patch 'mark_best/:answer_id', to: 'questions#mark_best', as: :mark_best
    delete 'delete_attachment/:file_id', to: 'questions#delete_attachment', as: :delete_attachment
    resources :answers, shallow: true
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
