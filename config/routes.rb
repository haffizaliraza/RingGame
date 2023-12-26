Rails.application.routes.draw do
  get 'dashboard/index'
  devise_for :users
  root to: 'dashboard#index', as: :authenticated_root
end
