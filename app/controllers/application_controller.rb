class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_filter :configure_permited_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected
  def configure_permited_parameters
    # parameters to allow during `sign_in`
    # devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:profile_name) }

    # parameters to allow during signup
<<<<<<< HEAD
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:last_name,
      :first_name, :email, :password, :password_confirmation, :uid, :name)}
=======
    devise_parameter_sanitizer.for(:sign_up) {
                          |u| u.permit(:last_name,
                                      :first_name,
                                      :email,
                                      :organization,
                                      :password,
                                      :password_confirmation,
                                      :uid,
                                      :name)}
>>>>>>> d3c7784dd323dd5beeb47d45d3c3a6011cafe892

    # paramters to allow during an `account update`
    # URL: http://localhost:3000/users/edit
    devise_parameter_sanitizer.for(:account_update) {
                          |u| u.permit(:last_name,
                                      :first_name,
                                      :uid,
                                      :name,
                                      :email,
                                      :organization,
                                      :password,
                                      :password_confirmation,
                                      :current_password)}
  end

  def layout_by_resource
    if devise_controller?
      "ordinary_application"
    else
      "application"
    end
  end



end
