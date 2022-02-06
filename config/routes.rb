Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  resources :photo_images, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resource  :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:show, :edit, :update] do
    resource :follows, only: [:create, :destroy]
    get 'followings' => 'follows#followings', as: 'followings'
    get 'follower' => 'follows#followers', as: 'followers'
  end
end
