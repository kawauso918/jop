Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
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

  get 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'done', to: 'contacts#done', as: 'done'
  resources :contacts, only: [:new, :create]

  resources :notifications, only: [:index, :destroy]

  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]

end
