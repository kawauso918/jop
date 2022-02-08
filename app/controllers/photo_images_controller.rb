class PhotoImagesController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @photo_image = PhotoImage.new
  end

  def create
    @photo_image = PhotoImage.new(photo_image_params)
    @photo_image.user_id = current_user.id
    if @photo_image.save
      redirect_to photo_images_path
    else
      render :new
    end

  end

  def index
    @photo_images = PhotoImage.page(params[:page]).reverse_order
  end

  def show
    @photo_image = PhotoImage.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @photo_image = PhotoImage.find(params[:id])
  end

  def update
    @photo_image = PhotoImage.find(params[:id])
    @photo_images = PhotoImage.all
    @photo_image.update(photo_image_params)
    redirect_to photo_image_path
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
