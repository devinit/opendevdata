class PagesController < ApplicationController
  autocomplete :dataset, :name

  layout :page_layout
  def index
    @recent_posts = Post.scoped limit: 3
    @recent_datasets = Dataset.scoped limit: 3
    @recent_documents = Document.scoped limit: 5
  end

  def about
  end

  private
  def page_layout
    if signed_in?
      "ordinary_application"
    else
      "application"
    end
  end

end
