class PhotoImagesController < ApplicationController
  def new
    @photo_image =PhotoImage.new
  end

  def create
    @photo_image =PhotoImage.new(photo_image_params)
    @photo_image.user_id =current_user.id
    @photo_image.save!
    redirect_to photo_images_path

  end

  def index
    @photo_images =PhotoImage.all
  end

  def show
    @photo_image =PhotoImage.find(params[:id])
    @comment =Comment.new
  end

  def edit
  end

  def update
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
end
