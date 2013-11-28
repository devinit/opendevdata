class PostsController < ApplicationController
  layout "ordinary_application"
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :get_post, only: [:edit, :show, :update, :destroy]

  def get_post
    @post = Post.find params[:id]
    rescue Mongoid::Errors::DocumentNotFound
      flash[:alert] = "The post you were looking for could not be found."
      redirect_to posts_path
  end

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
    if @post.user != current_user
      redirect_to posts_path, notice: "You don't have permission to edit this post."
    end
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
    if @post.user == current or @post.user.is_admin?
      @post.destroy
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
