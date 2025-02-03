Rails.application.routes.draw do
  resources :orders, only: %i[index show create] # Orders API
  resources :pizzas, only: %i[index show]           # List and show pizzas
  resources :toppings, only: %i[index show]         # List and show toppings
  resources :crusts, only: %i[index show]           # List and show crusts
  resources :sides, only: %i[index show]            # List and show sides
  resources :inventories, only: %i[index show]      # Inventory management

  root 'orders#index' # Default home page (optional)
end
