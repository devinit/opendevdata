class DocumentsController < ApplicationController
  layout "ordinary_application"

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :get_document, only: [:edit, :show, :update, :destroy]

  def get_document
    @document = Document.find(slug=params[:id])  # we are using slugs!
    rescue Mongoid::Errors::DocumentNotFound
      flash[:alert] = "The document you were looking for could not be found."
      redirect_to documents_path
  end

  def index
    @documents = Document.desc(:uploaded_on).page(params[:page])
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

  private
  def document_params
    params.require(:document).permit(:name, :description, :attachment)
  end

end
