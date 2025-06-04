Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  root to: "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :home, only: [:index]

  resources :houses, only: [:index, :show, :new, :create, :edit, :update] do
    resources :house_ingredients, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  end

  resources :recipes, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  resources :ingredients, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  # resources :ingredients, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :chats, only: [:index, :new, :create, :destroy] do
    resources :messages, only: [:create, :index, :destroy]
  end

get "/pages/dashboard", to: "pages#dashboard"
end
