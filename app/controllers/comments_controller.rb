class CommentsController < ApplicationController

  before_filter :authenticate_user!


  def new
    if params[:dataset_id]
      @dataset = Dataset.find slug=params[:dataset_id]
      @comment = @dataset.comments.new
      render "datasets/comments/new"
    end
  end


  def create
    to_redirect_obj = nil
    if params[:post_id]
      @post = Post.find params[:post_id]
      to_redirect_obj = @post
      @comment = @post.comments.create! comment_params
    elsif params[:dataset_id]
      @dataset = Dataset.find slug=params[:dataset_id]
      @comment  = @dataset.comments.create! comment_params
      to_redirect_obj = @dataset
    end

    if @comment.save and !to_redirect_obj.nil?
      redirect_to to_redirect_obj, notice: "Your comment has just been posted."
    else
      flash[:alert] = "Could not create your comment. Try again!"
      render :back
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content).merge!(user_id: current_user.id)
    end

end
