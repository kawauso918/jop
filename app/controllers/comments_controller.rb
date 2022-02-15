class CommentsController < ApplicationController
  def create
    @photo_image = PhotoImage.find(params[:photo_image_id])
    @comment = Comment.new(comment_params)
    @comment.photo_image_id = @photo_image.id
    @comment.user_id = current_user.id
    unless @comment.save
      render 'error'
    end
    @photo_image.create_notification_by(current_user)
  end

  def destroy
    @photo_image = PhotoImage.find(params[:photo_image_id])
    comment = @photo_image.comments.find(params[:id])
    comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
