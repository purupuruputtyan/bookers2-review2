Rails.application.routes.draw do

  devise_for :users
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"

  resources :books, only: [:create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      get 'daily_search' => 'users#daily_search'
  end

  get 'search' => 'searches#search'

  resources :chats, only: [:show, :create]

  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
  end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
