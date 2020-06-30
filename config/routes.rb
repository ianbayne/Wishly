Rails.application.routes.draw do
  root to: 'wishlists#new'

  resources :wishlists, only: [:new, :create, :show]
end
