Rails.application.routes.draw do
  resources :searches, only: [:new, :create] do
    resources :products, only: [:index]
  end

  root to: 'searches#new'
end
