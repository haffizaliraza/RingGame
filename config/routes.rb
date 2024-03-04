Rails.application.routes.draw do
  resources :shorts
  resources :games
  resources :teams do
    member do
      get :add_player
      post :create_player
    end
  end
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
  resources :users, only: %i[edit update] do
    member do
      delete :destroy_avatar
    end
  end
  root to: 'dashboard#public'
  get 'stats', to: 'dashboard#index', as: :authenticated_root
  get 'compare', to: 'dashboard#compare'

  namespace :api do
    post :auth, to: "authentication#create"
    delete :auth, to: "authentication#destroy"
    resources :shorts, only: :create
  end
end
