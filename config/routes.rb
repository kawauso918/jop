Rails.application.routes.draw do
  get 'maps/index'
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root to: 'homes#top'
  get '/home/about' => 'homes#about'
  resources :photo_images, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resource :follows, only: [:create, :destroy]
    get 'followings' => 'follows#followings', as: 'followings'
    get 'follower' => 'follows#followers', as: 'followers'
    collection do
      get 'search'
    end
  end
  # 問い合わせ機能
  get 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'done', to: 'contacts#done', as: 'done'
  resources :contacts, only: [:new, :create]
  # 通知機能
  resources :notifications, only: [:index, :destroy]
  # チャット機能
  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  # カレンダー機能
  resources :seminars, only: [:index]
  #地図表示
  get 'maps/index'
  root to: 'maps#index'
  resources :maps, only: [:index]

end
