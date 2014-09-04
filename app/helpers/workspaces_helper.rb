module WorkspacesHelper

  def has_access? workspace, user, dataset=nil
    state = false
    if dataset
      # hate duplication!
      state = (current_user == dataset.user) or current_user.is_admin?
    elsif workspace.nil?
      state = false
    else
      if signed_in? and current_user.is_admin?
        state = true
      else
        state = workspace.memberships.where(user: user, approved: true).exists?
      end
    end
    state
  end

  def has_change_access? workspace, user
    # user allowed to do danger changes
    workspace.memberships.where(user: user, admin: true).exists? or current_user.is_admin?
  end

end
