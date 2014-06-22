class WorkspacesController < ApplicationController
  before_filter :authenticate_user!
  # Note: here we'll go against the usual Rails b'se I'm tired
  # Workspace is analogous to an Organization

  def my_workspaces
    @workspaces = current_user.workspaces
  end

  def index
    @workspaces = Workspace.all
  end

  def new
    @workspace = Workspace.new
  end

  def create
    @workspace  = Workspace.create workspaces_params

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
    @workspace = Workspace.find params[:id]
    @datasets = Dataset.where workspace: @workspace
    _tags = @datasets.collect(&:tags).reject!(&:empty?)
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
      params.require(:workspace).permit(:organization_name, :description, :location)
    end

end
