Rails.application.routes.draw do
  resources :products, only: [:index, :show]

  resource :cart, only: [:show], controller: :cart do
    resources :items, only: [:create]
  end
end
