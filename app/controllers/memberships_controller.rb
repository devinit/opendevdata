class MembershipsController < ApplicationController
  def approve
    @membership = Membership.find params[:id]
    @membership.approved = true
    @membership.save

    respond_to do |format|
      format.js
      format.html { redirect_to [:open_workspaces, :pending], notice: "You've successfully approved #{@membership.user.first_name}'s membership." }
    end
  end
end
