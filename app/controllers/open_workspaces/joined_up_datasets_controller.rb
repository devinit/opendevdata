class OpenWorkspaces::JoinedUpDatasetsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_workspace

  def upload
  end

  def import
    logger.debug ">>> attempting import"
    JoinedUpDataset.import params[:file], current_user, @workspace
    logger.debug "<<< COMPLETE"
    redirect_to open_workspace_processing_url
  end

  def processing
  end

  def show
    @joined_up_dataset = JoinedUpDataset.find params[:id]
  end

  def index
    @joined_up_datasets = JoinedUpDataset.all
  end

  private
    def get_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

end
