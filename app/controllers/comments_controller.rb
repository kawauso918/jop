class CommentsController < ApplicationController
  def create
    photo_image = PhotoImage.find(params[:photo_image_id])
    comment = current_user.comments.new(comment_params)
    comment.photo_image_id = photo_image.id
    comment.save!
    redirect_to photo_image_path(photo_image)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
