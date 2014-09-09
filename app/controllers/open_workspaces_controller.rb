class OpenWorkspacesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :grant_access!, only: [:edit, :update, :destroy]
  # Note: here we'll go against the usual Rails b'se I'm tired
  # Workspace is analogous to an Organization

  def my_workspaces
    @workspaces = current_user.workspaces
  end

  def apply_to_join
    @workspace = OpenWorkspace.find params[:id]
    @workspace.apply_to_join(current_user)
    @workspace.save
    respond_to do |format|
      format.html { redirect_to @workspace }
      format.js
    end
  end

  def pending
    @workspace = OpenWorkspace.find_by_slug! params[:id]
    @memberships = @workspace.memberships.where(approved: false)
  end

  def leave_workspace
    @workspace = OpenWorkspace.find params[:id]
    if !@workspace.memberships.where(user: current_user, admin: true).exists?
      @workspace.memberships.where(user: current_user).delete()
      redirect_to @workspace
    else
      redirect_to root_path, alert: "You cannot remove yourself from the group. Please contact admin for a smooth migration policy"
    end
  end

  def index
    @workspaces = OpenWorkspace.where(approved: true)
  end

  def new
    @workspace = OpenWorkspace.new
  end

  def create
    @workspace  = OpenWorkspace.create workspaces_params

    if @workspace.save
      # given that you reach stage, lets change a few things
      if !@workspace.memberships.where(user: current_user, admin: true, approved: true).exists?
        m = @workspace.memberships.create user: current_user, admin: true, approved: true
        m.save  # save this member as admin! :-)
        @workspace.save # re-save this
      end

      redirect_to @workspace, notice: 'You have successfully created a workspace.'
    else
      flash[:alert] = "You cannot create a workspace. Please contact site administrator"
      render "new"
    end
  end

  def show
    @workspace = OpenWorkspace.find params[:id]
    @datasets = @workspace.datasets.where approved: true
    @documents = @workspace.documents

    _tags = @datasets.collect(&:tags)
    _tags.reject!(&:empty?)
    # cleanup
    @tags = []
    if !_tags.nil?
      _tags.each do |tag|
        _tag_split = tag.split(',')
        _tag_split.each do |_tagged|
          @tags << _tagged
        end
      end
    end
    # sanitize (only unique tags)
    @tags.uniq!

    @admins = @workspace.memberships.where(admin: true)

  end


  def edit
    @workspace = OpenWorkspace.find params[:id]
  end

  def approve
    @workspace = OpenWorkspace.find params[:id]
    @workspace.approved = true
    @workspace.save
    respond_to do |format|
      format.html { redirect_to @workspace }
    end
  end

  def unapproved
    @workspaces = OpenWorkspace.where approved: false
  end

  def update
    @workspace = OpenWorkspace.find params[:id]
    if @workspace.has_change_access? current_user
      if @workspace.update_attributes workspaces_params
        redirect_to @workspace, notice: "You've successfully updated your workspace."
      else
        flash[:alert] = "You cannot update your workspace. Please contact admin."
      end
    else
      redirect_to root_path, alert: "Attempted to wrongfully update workspace."
    end
  end

  def destroy
    @workspace = OpenWorkspace.find params[:id]
    if @workspace.has_change_access? current_user
      @workspace.destroy
    else
      redirect_to root_path, alert: "You don't have permission to do this."
    end
  end

  private
    def workspaces_params
      params.require(:open_workspace).permit(:organization_name, :description, :location)
    end

    def grant_access!
      @workspace = OpenWorkspace.find params[:id]
      if !@workspace.has_change_access? current_user
        redirect_to root_path, alert: "You don't have permission to do this."
      end
    end
end
