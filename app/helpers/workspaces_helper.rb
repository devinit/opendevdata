module WorkspacesHelper
  def has_access? workspace, user, dataset=nil
    if dataset
      # hate duplication!
      current_user == dataset.user or current_user.is_admin?
    elsif workspace.nil?
      false
    else
      if signed_in? and current_user.is_admin?
        true
      else
        workspace.memberships.where(user: user, approved: true).exists?
      end
    end

  end

  def has_change_access? workspace, user
    # user allowed to do danger changes
    workspace.memberships.where(user: user, admin: true).exists?
  end

end
