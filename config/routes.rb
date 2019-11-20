Rails.application.routes.draw do
  devise_for :users
  # root to: 'wishlists#index'

  resources :wishlists, only: [:show, :new, :create, :edit, :update, :destroy]
end
