class PagesController < ApplicationController
  layout :page_layout

  def index
    @recent_datasets = Dataset.scoped limit: 3
    @recent_documents = Document.scoped limit: 5

    if params[:search].nil?
      @datasets = Dataset.scoped limit: 10
    else
      @datasets = Dataset.search(params[:search]).delete_if { |x| x.empty? or x.nil? }
    end
  end

  def about
  end

  def admin
    @dataset_count = Dataset.count
    @dataset_view = Dataset.all.inject(0) { |result, element| result + element.view_count }
    @user_count = User.count
    @document_count = Document.count
  end

  def developer
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
