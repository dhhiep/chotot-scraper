Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  devise_for :users
  devise_scope :user do
    get "sign-in",          to: "devise/sessions#new"
    post "sign-in",         to: "devise/sessions#create"
    get "sign-out",         to: "devise/sessions#destroy"
    # get "sign-up",          to: "devise/registrations#new"
    # post "register",        to: "registrations#create"
    # get "forgot-password",  to: "devise/passwords#new"
    # post "forgot-password", to: "devise/passwords#create"
  end

  resources :accounts, only: [:index]
  resources :lists, only: [:index]
  resources :categories, only: [:index]
  resources :logs, only: [:index]

  root 'accounts#index'
end
