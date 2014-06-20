class WorkspacesController < ApplicationController
  before_filter :authenticate_user!
  # Note: here we'll go against the usual Rails b'se I'm tired
  # Workspace is analogous to an Organization

  def new
    @workspace = Workspace.new
  end

  def create
    @workspace  = Workspace.create workspaces_params
    if @workspace.save
      # given that you reach stage, lets change a few things
      m = @workspace.memberships.create user: current_user, admin: true, approved: true
      m.save  # save this member as admin! :-)
      redirect_to @workspace, notice: 'You have successfully created a workspace.'
    else
      flash[:alert] = "You cannot create a workspace. Please contact site administrator"
      render "new"
    end
  end

  def edit
    @workspace = Workspace.find params[:id]
  end

  def update
    @workspace = Workspace.find params[:id]
    if @workspace.update_attributes workspaces_params
      redirect_to @workspace, notice: "You've successfully updated your workspace."
    else
      flash[:alert] = "You cannot update your workspace. Please contact admin."
    end
  end

  def destroy
    @workspace = Workspace.find params[:id]
    @workspace.destroy
  end

  private
    def workspaces_params
      params.require(:dataset).permit(:organization_name, :location)
    end

end
