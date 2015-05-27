class OpenWorkspaces::FeedbacksController < ApplicationController
  before_filter :get_workspace

  def new
    @feedback = Feedback.new
  end

  def show
    @feedback = @workspace.feedbacks.find params[:id]

    render json: @feedback
  end

  def create
    first_name = params[:first_name]
    last_name = params[:last_name]
    remarks = params[:remarks]
    gender = params[:gender]
    workspace_id = params[:workspace_id]
    @workspace = OpenWorkspace.find_by id: workspace_id
    @feedback = Feedback.new

    @feedback.first_name = first_name
    @feedback.last_name = last_name
    @feedback.remarks = remarks
    @feedback.gender = gender

    if @feedback.save
      render json: @feedback, status: :created, location: [@workspace, @feedback]
    else
      render json: @feedback.errors, status: :unprocessable_entity
    end
  end

  private
    def get_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

    def feedback_params
      params.require(:feedback).permit(
        :country,
        :remarks,
        :first_name,
        :last_name,
        :gender
      )
    end

end
