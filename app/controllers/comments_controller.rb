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
    @post = Post.find params[:post_id]
    @comment = @post.comments.create! comment_params
    if @comment.save
      redirect_to @post, notice: "Your comment has just been posted."
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
