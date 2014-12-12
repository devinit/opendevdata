class OpenWorkspaces::JoinedUpDatasetStepsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace
  before_action :current_joined_up_dataset

  include Wicked::Wizard
  steps :data_choice, :time_space_format_choice, :data_series_choice, :name_of_joined_up_dataset

  def show
    render_wizard
  end

  def update
    case step

    when :name_of_joined_up_dataset
      @joined_up_dataset.update_attributes joined_up_dataset_params.merge({pending: false})
      session[:joined_up_dataset_id] = nil  # flash out joined up dataset
    end

    render_wizard @joined_up_dataset
  end

  private
    def joined_up_dataset_params
      params.require(:joined_up_dataset).permit(:name, :source_of_data)
    end

    def find_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

    def current_joined_up_dataset
      @joined_up_dataset ||= JoinedUpDataset.find_by id: session[:joined_up_dataset_id]
    end
end
