class FavoritesController < ApplicationController
   before_action :authenticate_user!

  def create
    @photo_image = PhotoImage.find(params[:photo_image_id])
    favorite = @photo_image.favorites.new(user_id: current_user.id)
    favorite.save
    # app/views/favorites/create.js.erbを参照する
  end

  def destroy
    @photo_image = PhotoImage.find(params[:photo_image_id])
    favorite = @photo_image.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    # app/views/favorites/destroy.js.erbを参照する
  end

end
