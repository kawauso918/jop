class FavoritesController < ApplicationController
  def create
    photo_image = PhotoImage.find(params[:photo_image_id])
    favorite = current_user.favorites.new(photo_image_id: photo_image.id)
    favorite.save
    redirect_to request.referer
  end

  def destroy
    photo_image = PhotoImage.find(params[:photo_image_id])
    favorite = current_user.favorites.find_by(photo_image_id: photo_image.id)
    favorite.destroy
    redirect_to request.referer
  end

end
