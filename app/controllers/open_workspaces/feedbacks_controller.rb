class OpenWorkspaces::FeedbacksController < ApplicationController
  before_filter :get_workspace

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.create feedback_params.merge(open_workspace: @workspace)
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
