Rails.application.routes.draw do
  get 'dashboard/index'
  devise_for :users
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  root to: 'welcome#index'
end
