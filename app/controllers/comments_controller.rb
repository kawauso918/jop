class CommentsController < ApplicationController
  def create
    @photo_image = PhotoImage.find(params[:photo_image_id])
    @comment = Comment.new(comment_params)
    @comment.photo_image_id = @photo_image.id
    @comment.user_id = current_user.id
    unless @comment.save
      # app/views/comments/create.js.erbを参照する
      render 'error'
    end
    # 通知機能について
    @photo_image.create_notification_by(current_user)
  end

  def destroy
    @photo_image = PhotoImage.find(params[:photo_image_id])
    comment = @photo_image.comments.find(params[:id])
    if comment.user_id == current_user.id
      comment.destroy
    end
     # app/views/comments/destroy.js.erbを参照する
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
