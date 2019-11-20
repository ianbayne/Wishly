Rails.application.routes.draw do
  get 'users/index'
  devise_for :users
  root to: 'users#index'

  resources :wishlists, only: [:show, :new, :create, :edit, :update, :destroy]
end
