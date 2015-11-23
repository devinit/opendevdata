class ApiTokensController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.update(authentication_token: nil)
    redirect_to developer_path, notice: "Successfully reset token!"
  end

end
