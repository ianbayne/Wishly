Rails.application.routes.draw do
  devise_for :users
  # For devise, ensure you have defined root_url to something
  # root to: 'home#index'
end
