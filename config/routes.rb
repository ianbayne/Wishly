Rails.application.routes.draw do
  devise_for :users
  root to: 'users#index'

  resources :wishlists, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :wishlist_items
  end
end
