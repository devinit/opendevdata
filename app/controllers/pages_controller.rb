class PagesController < ApplicationController
  def index
    @recent_posts = Post.first
  end


  def about
  end

end
