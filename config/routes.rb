Rails.application.routes.draw do
  resources :shorts
  resources :games
  get 'dashboard/index'
  devise_for :users
  resources :users, only: %i[edit update]
  root to: 'dashboard#index', as: :authenticated_root

  namespace :api do
    post :auth, to: "authentication#create"
    delete :auth, to: "authentication#destroy"
    resources :shorts, only: :create
  end
end
