class AuthenticationsController < ApplicationController
  include Authenticatable
  before_action :ensure_authenticated, only: [:destroy]
  before_action :ensure_not_authenticated, only: [:new, :create]

  def new
    @user = User.new

    if session[:user_id]
      redirect_to overview_path
    else
      render "new"
    end
  end

  def create
    @user = User.find_by(email: auth_params[:email])

    if @user&.authenticate(auth_params[:password])
      session[:user_id] = @user.id
      redirect_to overview_path
    else
      flash[:danger] = "Login failed. Please try again."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  private

  def auth_params
    params.require(:user).permit(:email, :password)
  end
end
