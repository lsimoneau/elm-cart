Rails.application.routes.draw do
  root "products#index"

  resources :products, only: [:index, :show]

  resource :cart, only: [:show], controller: :cart do
    resources :items, only: [:create]
    resource :payment, only: [:create]
  end
end
