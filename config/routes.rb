Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  root to: "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :home, only: [:index]

  resources :pages, only: [:index, :show, :new, :create, :edit, :update] do

  end
  resources :houses, only: [:index, :show, :new, :create, :edit, :update] do
    resources :house_ingredients do
      collection do
        #ajout de cet élément pour crééer une route path
        post :analyze_ticket
        get :review_parsed_products
        post :confirm_parsed_products
      end
    end
  end

  # suppression et création des steps pour les form de recipes/new et recipes/edit
  resources :steps, only: [:new, :destroy]

  resources :recipes, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    collection do
      get :llm_index
    end
    member do
      post :mark_as_done
      patch :toggle_favorite

    end
  end

  resources :ingredients, only: [:index]
  # resources :ingredients, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :chats, only: [:index, :new, :create, :destroy] do
    resources :messages, only: [:create, :index, :destroy]
  end

  get "/pages/dashboard", to: "pages#dashboard"
end
