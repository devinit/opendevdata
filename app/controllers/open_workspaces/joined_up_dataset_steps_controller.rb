class OpenWorkspaces::JoinedUpDatasetStepsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace
  before_action :current_joined_up_dataset

  include Wicked::Wizard
  steps :name_of_joined_up_dataset, :data_choice, :time_space_format_choice, :data_series_choice

  def show
    render_wizard
  end

  def update
    case step

    when :name_of_joined_up_dataset
      @joined_up_dataset.update_attributes joined_up_dataset_params.merge({pending: false})
    end

    render_wizard @joined_up_dataset
  end

  def finish_wizard_path
    open_workspace_joined_up_dataset_path(@workspace, current_joined_up_dataset.id)
  end

  private
    def joined_up_dataset_params
      # cleaning things up
      params[:joined_up_dataset][:status] = step.to_s
      params[:joined_up_dataset][:status] = 'all_fields' if step == steps.last
      params.require(:joined_up_dataset).permit(:name, :source_of_data, :status, :description, :note, :tags)
    end

    def find_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

    def current_joined_up_dataset
      @joined_up_dataset ||= JoinedUpDataset.find_by id: session[:joined_up_dataset_id]
    end
end
