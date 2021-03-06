Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  devise_for :users
  devise_scope :user do
    get 'sign-in',          to: 'devise/sessions#new'
    post 'sign-in',         to: 'devise/sessions#create'
    get 'sign-out',         to: 'devise/sessions#destroy'
    # get 'sign-up',          to: 'devise/registrations#new'
    # post 'register',        to: 'registrations#create'
    # get 'forgot-password',  to: 'devise/passwords#new'
    # post 'forgot-password', to: 'devise/passwords#create'
  end

  resources :accounts, only: [:index] do
    collection do
      get :favorites, action: :index, type: 'favorites'
      get :fetch_summary
    end

    member do
      post :fetch_zalo_info
      post :mark_wse_status
      post :mark_review
      post :toggle_favorite
      post :hide
    end
  end

  resources :potentials
  resources :lists, only: [:index]
  resources :categories, only: [:index]
  resources :logs, only: [:index, :show]

  root 'accounts#index'
end
