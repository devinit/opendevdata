class OpenWorkspaces::JoinedUpDatasetsController < ApplicationController

  before_action :authenticate_user!

  def upload
  end

  def show
    @joined_up_dataset = JoinedUpDataset.find params[:id]
  end

  def index
    @joined_up_datasets = JoinedUpDataset.all
  end


end
