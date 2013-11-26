class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.order_by('published_on DESC').page(params[:page])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.create post_params
    if @post.save
      redirect_to @post, notice: "Post created"
    else
      flash[:alert] = "Could not create post. Please try again."
      render "new"
    end
  end

  def show
    @post = Post.find params[:id]
  end

  def edit
    @post = current_user.posts.find params[:id]
  end

  def update
    if @post.update_attributes post_params
      redirect_to @post, notice: "Post has been updated successfully"
    else
      flash[:notice] = "Could not update your post. Please try again."
      render "edit"
    end
  end

  def destroy
    @post = current_user.posts.find params[:id]
    if @post.destroy
      flash[:notice] = "You have successfully deleted the post."
    else
      flash[:alert] = "You can't destroy this post."
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :content)
    end

end
