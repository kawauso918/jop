class PhotoImagesController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  impressionist :actions=> [:show]

  def new
    @photo_image = PhotoImage.new
  end

  def create
    @photo_image = PhotoImage.new(photo_image_params)
    @photo_image.user_id = current_user.id
    if @photo_image.save
      # タグの保存
      @photo_image.save_tags(params[:photo_image][:tag])
      redirect_to photo_images_path, notice: 'You have created photo_image successfully.'
    else
      render :new
    end
  end

  def index
    @photo_images = PhotoImage.page(params[:page]).reverse_order
    @all_ranks = PhotoImage.find(Favorite.group(:photo_image_id).order('count(photo_image_id) desc').limit(3).pluck(:photo_image_id))
  end

  def show
    @photo_image = PhotoImage.find(params[:id])
    @comment = Comment.new
    impressionist(@photo_image, nil, unique: [:session_hash.to_s])
  end

  def edit
    @photo_image = PhotoImage.find(params[:id])
  end

  def update
    @photo_image = PhotoImage.find(params[:id])
    @photo_images = PhotoImage.all
    if @photo_image.update(photo_image_params)
       # タグの更新
      @photo_image.save_tags(params[:photo_image][:tag])
      redirect_to photo_image_path, notice: 'You have updated photo_image successfully.'
    else
      render :edit
    end
  end

  def destroy
    @photo_image = PhotoImage.find(params[:id])
    @photo_image.destroy
    redirect_to photo_images_path
  end

  private

  def photo_image_params
    params.require(:photo_image).permit(:name, :image, :caption)
  end

  def ensure_correct_user
    @photo_image = PhotoImage.find(params[:id])
    unless @photo_image.user == current_user
      redirect_to photo_images_path
    end
  end
end
