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

  def ban
    if current_user.is_admin?
      @user = User.find params[:id]
      @user.ban_user!
      @user.save
      respond_to do |format|
        format.html { redirect_to users_path }
        format.js
      end
    end
  end


  def unban
    if current_user.is_admin?
      @user = User.find params[:id]
      @user.unban_user!
      @user.save
      respond_to do |format|
        format.html { redirect_to users_path }
        format.js
      end
    end
  end

  def make_admin
    if current_user.is_admin?
      @user = User.find params[:id]
      @user.make_admin
      @user.save
      respond_to do |format|
        format.html { redirect_to users_path }
        format.js
      end
    end
  end

  def remove_admin
    if current_user.is_admin?
      @user = User.find params[:id]
      @user.remove_admin
      @user.save
      respond_to do |format|
        format.html { redirect_to users_path }
        format.js
      end
    end
  end

end
