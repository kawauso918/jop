class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :authenticate_user!
  before_action :set_q, only: [:index, :search]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @photo_images = @user.photo_images.page(params[:page]).reverse_order
    @all_ranks = PhotoImage.find(Favorite.group(:photo_image_id).order('count(photo_image_id) desc').limit(3).pluck(:photo_image_id))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end

  def search
    @results = @q.result
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def set_q
    @q = User.ransack(params[:q])
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

end
