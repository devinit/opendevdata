module WorkspacesHelper
  def has_access? workspace, user
    if workspace.nil?
      false
    else
      workspace.memberships.where(user: user, approved: true).exists?
    end
  end

  def has_change_access? workspace, user
    # user allowed to do danger changes
    workspace.memberships.where(user: user, admin: true).exists?
  end

end
