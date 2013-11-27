class UsersController < ApplicationController
  layout "ordinary_application"

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find params[:id]
  end


  def destroy
    if current_user.is_admin?
      @user = User.find params[:id]
      name = @user.full_name
      @user.destroy
      redirect_to users_path, notice: "You have successfully deleted #{name}"
    else
      redirect_to users_path, alert: "You cannot delete this user"
    end
  end

end
