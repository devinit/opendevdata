class Workspaces::DocumentsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :get_workspace
  before_filter :grant_access!, only: [:new, :create, :edit, :update, :destroy]

  def index
    # @documents = @workspace.documents.all
    if params[:search].nil?
      @documents = @workspace.documents.desc(:uploaded_on).page(params[:page])
    else
      @documents = @workspace.documents.search(params[:search]).uniq.delete_if { |doc| doc.empty? or doc.nil? }
    end
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.create document_params.merge(user: current_user,
                                                  workspace: @workspace)
    if @document.save
      # redirect_to [@workspace, @dataset], notice: "You've successfully uploaded a dataset"
      redirect_to open_workspace_document_path(@workspace, @document), notice: "You've successfully uploaded a document"
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
      @workspace = OpenWorkspace.find params[:workspace_id]
    end

    def document_params
      params.require(:document).permit(
        :name,
        :description,
        :attachment,
        :tags)
    end

    def grant_access!
      if !@workspace.memberships.where(user: current_user, approved: true).exists?
        redirect_to root_path, alert: "You don't have permission to do this"
      end
    end

end
