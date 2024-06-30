class AuthenticationsController < ApplicationController
  include Authenticatable
  before_action :ensure_authenticated, only: [:destroy]
  before_action :ensure_not_authenticated, only: [:new, :create]

  def new
    @user = User.new
    StatsD.increment("login_page_viewed")

    if session[:user_id]
      StatsD.increment("already_logged_in")
      redirect_to overview_path
    else
      StatsD.increment("login_page_viewed")
      render "new"
    end
  end

  def create
    @user = User.find_by(email: auth_params[:email])
    StatsD.increment("login_attempt")

    if @user&.authenticate(auth_params[:password])
      StatsD.increment("login_successful")
      session[:user_id] = @user.id
      redirect_to overview_path
    else
      StatsD.increment("login_failed")
      flash[:danger] = "Login failed. Please try again."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    StatsD.increment("logout")
    redirect_to login_path
  end

  private

  def auth_params
    params.require(:user).permit(:email, :password)
  end
end
