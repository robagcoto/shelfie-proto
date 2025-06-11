Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  root to: "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :home, only: [:index]

  resources :pages, only: [:index, :show, :new, :create, :edit, :update] do

  end
  resources :houses, only: [:index, :show, :new, :create, :edit, :update] do
    resources :house_ingredients, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  end

  # suppression et création des steps pour les form de recipes/new et recipes/edit
  resources :steps, only: [:new, :destroy]

  resources :recipes, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    member do

      post :mark_as_done
      patch :toggle_favorite

    end
  end

  resources :ingredients, only: [:index]
  # resources :ingredients, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :chats, only: [:index, :new, :create, :destroy] do
    resources :messages, only: [:create, :index, :destroy] do
      member do
        post :create_dlc
      end
    end
    collection do
      post :create_chat_dlc
    end
  end

  get "/pages/dashboard", to: "pages#dashboard"
end
