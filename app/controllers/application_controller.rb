class ApplicationController < ActionController::Base
  before_filter :configure_permited_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def configure_permited_parameters
    # parameters to allow during `sign_in`
    # devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:profile_name) }

    # parameters to allow during signup
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:last_name,
      :first_name, :email, :password, :password_confirmation)}

    # paramters to allow during an `account update`
    # URL: http://localhost:3000/users/edit
    devise_parameter_sanitizer.for(:account_update) {
                          |u| u.permit(:last_name,
                                      :first_name,
                                      :email,
                                      :password,
                                      :password_confirmation,
                                      :current_password)}
  end


end
