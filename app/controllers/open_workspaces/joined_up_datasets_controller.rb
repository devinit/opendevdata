class OpenWorkspaces::JoinedUpDatasetsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_workspace

  # Some differences with how we are working with REST
  # - upload (a user will put in a CSV or use their existing excel utilities
  # to convert existing data to a CSV format (hopefully it will be standard
  # - to update a dataset, user basically has to attach a newer CVS file or
  # Delete the joined up dataset)
  def upload
  end

  def import
    JoinedUpDataset.import params[:file], current_user, @workspace
    redirect_to open_workspace_processing_url(@workspace)
  end

  def processing
  end

  def pending
    @pending = JoinedUpDataset.where pending: true
  end

  def show
    @joined_up_dataset = JoinedUpDataset.find params[:id]
  end

  def index
    @joined_up_datasets = JoinedUpDataset.all
  end

  def destroy
  end

  def update
  end

  private
    def get_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

end
