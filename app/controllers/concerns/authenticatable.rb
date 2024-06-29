# frozen_string_literal: true

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
    unless is_authenticated?
      flash[:warning] = "You need to login to view that page."
      redirect_to main_app.login_path
    end
  end

  def ensure_not_authenticated
    if is_authenticated?
      flash[:info] = "You are already logged in."
      redirect_to root_path
    end
  end
end
