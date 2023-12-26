Rails.application.routes.draw do
  resources :shorts
  resources :games
  get 'dashboard/index'
  devise_for :users
  root to: 'dashboard#index', as: :authenticated_root
end
