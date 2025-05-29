Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :home, only: [:index]
  resources :recipes, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  # resources :ingredients, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :chats, only: [:index, :show, :new, :create, :destroy] do
    resources :messages, only: [:create, :index]
  end

get "/pages/dashboard", to: "pages#dashboard"
end
