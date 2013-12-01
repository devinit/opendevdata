class PagesController < ApplicationController
  def index
    @recent_posts = Post.scoped(limit: 3)
    @recent_datasets = Dataset.scoped(limit: 3)
  end

  def about
  end

end
