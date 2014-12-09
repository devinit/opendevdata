class OpenWorkspaces::JoinedUpDatasetStepsController < ApplicationController
  before_action :find_workspace, only: [:show,:update]
  before_action :current_joined_up_dataset

  include Wicked::Wizard
  steps :data_choice, :time_space_format_choice, :data_series_choice

  def show
    render_wizard
  end

  def update
    case step
    when :data_series_choice
      @joined_up_dataset.update_attributes joined_up_dataset_params
    end
    render_wizard @joined_up_dataset
  end

  private
    def joined_up_dataset_params
      params.require(:joined_up_dataset).permit(:data_series_id)
    end

    def find_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

    def current_joined_up_dataset
      @joined_up_dataset ||= JoinedUpDataset.find_by id: session[:joined_up_dataset_id]
    end
end
