module WorkspacesHelper
  def has_access? workspace, user
    workspace.memberships.where(user: user, approved: true).exists?
  end

  def has_change_access? workspace, user
    # user allowed to do danger changes
    workspace.memberships.where(user: user, admin: true).exists?
  end
end
