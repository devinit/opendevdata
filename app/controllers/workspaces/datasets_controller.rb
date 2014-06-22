class Workspaces::DatasetsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_filter :get_workspace

  def index
    @datasets = @workspace.datasets.all

    @tags = []
    @datasets.tags.each do |tag|
      @tags << tag
    end

    if params[:search].nil?
      @datasets = @datasets.desc(:created_at).page(params[:page])
    else
      @datasets = @datasets.search(params[:search]).uniq.delete_if { |dataset| dataset.nil? or dataset.empty? }
    end
  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset= Dataset.create dataset_params.merge(user: current_user,
                                                  workspace: @workspace)
    if @dataset.save
      # redirect_to [@workspace, @dataset], notice: "You've successfully uploaded a dataset"
      redirect_to workspace_dataset_path(@workspace, @dataset), notice: "You've successfully uploaded a dataset"
    else
      flash[:alert] = "Failed to save"
      render "new"
    end
  end

  def show
    @dataset = @workspace.datasets.find params[:id]
    @comments = @dataset.comments.all
  end

  def edit
    @dataset = @workspace.datasets.find params[:id]
  end

  def update
    @dataset = @workspace.datasets.find params[:id]
    if @dataset.update_attributes dataset_params
      redirect_to workspace_dataset_path(@workspace, @dataset)
    else
      flash[:alert] = 'Could not update your dataset. Contact Admin'
      render "edit"
    end
  end

  private
    def get_workspace
      @workspace = Workspace.find params[:workspace_id]
    end

    def dataset_params
      params.require(:dataset).permit(
        :name,
        :description,
        :attachment,
        :chart_type,
        :x_label,
        :y_label,
        :sub_title,
        :title,
        :data_units,
        :tags)
    end

end
