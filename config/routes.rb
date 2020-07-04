Rails.application.routes.draw do
  root to: 'wishlists#new'

  resources :wishlists, only: [:new, :create, :show] do
    post 'wishlist_items/:id', to: 'purchases#create', as: 'item_purchase'
    delete 'wishlist_items/:id', to: 'purchases#destroy', as: 'item_cancel_purchase'
  end
end
