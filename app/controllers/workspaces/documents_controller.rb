class Workspaces::DocumentsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_filter :get_workspace

  def index
    @documents = @workspace.documents.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.create document_params.merge(user: current_user,
                                                  workspace: @workspace)
    if @document.save
      # redirect_to [@workspace, @dataset], notice: "You've successfully uploaded a dataset"
      redirect_to workspace_document_path(@workspace, @document), notice: "You've successfully uploaded a document"
    else
      flash[:alert] = "Failed to save"
      render "new"
    end
  end

  def show
    @document = @workspace.documents.find params[:id]
    @comments = @document.comments.all
  end

  private
    def get_workspace
      @workspace = Workspace.find params[:workspace_id]
    end

    def document_params
      params.require(:document).permit(
        :name,
        :description,
        :attachment,
        :tags)
    end

end
