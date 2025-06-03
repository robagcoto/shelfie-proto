Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  root to: "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :home, only: [:index]

  resources :house, only: [:index, :show, :new, :create, :edit, :update]

  resources :recipes, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  # resources :ingredients, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :chats, only: [:index, :new, :create, :destroy] do
    resources :messages, only: [:create, :index, :destroy]
  end

get "/pages/dashboard", to: "pages#dashboard"
end
