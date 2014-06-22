class DocumentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :get_document, only: [:edit, :show, :update, :destroy]

  def get_document
    @document = Document.find(slug=params[:id])  # we are using slugs!
    rescue Mongoid::Errors::DocumentNotFound
      flash[:alert] = "The document you were looking for could not be found."
      redirect_to documents_path
  end

  def index
    if params[:search].nil?
      @documents = Document.desc(:uploaded_on).page(params[:page])
    else
      @documents = Document.search(params[:search]).uniq.delete_if { |doc| doc.empty? or doc.nil? }
    end
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.create(document_params.merge(user: current_user))
    if @document.save
      redirect_to @document, notice: "You have successfully uploaded the document."
    else
      flash[:alert] = "You could not upload the document. Something bad happened!"
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def destroy
    if @document.user == current_user or @document.user.is_admin?
      @document.destroy
      flash[:success] = "You successfully delete the document."
    else
      flash[:alert] = "You don't have sufficient rights to delete this document. Only the uploader can delete it."
    end
    redirect_to documents_path
  end

  private
  def document_params
    params.require(:document).permit(:name, :description, :attachment, :tags)
  end
end
