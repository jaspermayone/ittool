module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :ensure_authenticated
  end

  def is_authenticated?
    session[:user_id].present?
  end

  def is_not_authenticated?
    !is_authenticated?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if is_authenticated?
  end

  def ensure_authenticated
    StatsD.measure('auth.ensure_authenticated') do
      unless is_authenticated?
        flash[:warning] = "You need to login to view that page."
        StatsD.event('Authentication Failure', 'User not authenticated, redirecting to login')
        redirect_to main_app.login_path
      end
    end
  end

  def ensure_not_authenticated
    StatsD.measure('auth.ensure_not_authenticated') do
      if is_authenticated?
        flash[:info] = "You are already logged in."
        StatsD.event('Already Authenticated', 'User already logged in, redirecting to root')
        redirect_to root_path
      end
    end
  end

  def ensure_admin
    StatsD.measure('auth.ensure_admin') do
      unless current_user&.admin?
        flash[:danger] = "You do not have permission to view that page."
        StatsD.event('Admin Access Denied', 'Non-admin user attempted to access admin page')
        redirect_to root_path
      end
    end
  end

  def ensure_super_admin
    StatsD.measure('auth.ensure_super_admin') do
      unless current_user&.super_admin?
        flash[:danger] = "You do not have permission to view that page."
        StatsD.event('Super Admin Access Denied', 'Non-super-admin user attempted to access super admin page')
        redirect_to root_path
      end
    end
  end
end
