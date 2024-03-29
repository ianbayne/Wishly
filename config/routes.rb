Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'pages#home'

  resources :wishlists, only: [:new, :create, :show, :edit, :update] do
    post 'wishlist_items/:id', to: 'purchases#create', as: 'item_purchase'
    delete 'wishlist_items/:id', to: 'purchases#destroy', as: 'item_cancel_purchase'
  end
end
