class PagesController < ApplicationController

  def index
    @recent_datasets = Dataset.scoped limit: 3
    @recent_documents = Document.scoped limit: 5

    _tags = Dataset.all.collect(&:tags).reject!(&:empty?)
    # cleanup
    @tags = []
    _tags.each do |tag|
      _tag_split = tag.split(',')
      _tag_split.each do |_tagged|
        @tags << _tagged
      end
    end

    # sanitize (only unique tags)
    @tags.uniq!

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

end
