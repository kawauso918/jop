class CommentsController < ApplicationController
  def create
    photo_image = PhotoImage.find(params[:photo_image_id])
    comment = current_user.comments.new(comment_params)
    comment.photo_image_id = photo_image.id
    comment.save!
    redirect_to request.referer
  end

  def destroy
    Comment.find_by(id: params[:id]).destroy
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
