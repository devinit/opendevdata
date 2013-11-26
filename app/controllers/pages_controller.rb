class PagesController < ApplicationController
  def index
    @recent_posts = Post.all
  end


  def about
  end

end
