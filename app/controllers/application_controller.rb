class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  helper_method :current_user, :user_is_admin?, :system_is_trial?, :trial_days_remaining


  def current_user
    @current_user ||= User.find(session[:user]["user_id"]) rescue nil if session[:user]
  end

  def authorize
    redirect_to ("/login") and return  unless current_user
    redirect_to ("/package_expired") and return if SystemPlan.trial_ended?
  end

  def user_is_admin?
    admin = false
    role = @current_user.person.role rescue ""
    admin = true if role.to_s.match(/Administrator/i)
    admin
  end

  def check_admin_privileges
    redirect_to "/", flash: {error: "You dont have enough permissions to perform that action"} if !user_is_admin?
  end

  def system_is_trial?
    SystemPlan.is_trial?
  end

  def trial_days_remaining
    SystemPlan.trial_days_remaining
  end

end
