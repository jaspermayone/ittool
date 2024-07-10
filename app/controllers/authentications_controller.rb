class AuthenticationsController < ApplicationController
  include Authenticatable
  before_action :ensure_authenticated, only: [:destroy]
  before_action :ensure_not_authenticated, only: [:new, :create]

  def new
    # # StatsD.increment("login_page_viewed")

    # Measure the time taken to process the rendering of the new page
    # StatsD.measure('view.render_login_page') do
      if session[:user_id]
        # StatsD.increment("already_logged_in")
        redirect_to overview_path
      else
        render "new"
      end
    end
  end

  def create
    # StatsD.increment("login_attempt")

    # Measure the time taken for the authentication process
    # StatsD.measure('auth.authenticate_user') do
      @user = User.find_by(email: auth_params[:email])
      if @user&.authenticate(auth_params[:password])
        # StatsD.increment("login_successful")
        session[:user_id] = @user.id
        # StatsD.set('users.unique_logged_in', @user.id) # Track unique users logging in
        redirect_to overview_path
      else
        # StatsD.increment("login_failed")
        flash[:danger] = "Login failed. Please try again."
        render "new"
      # end
    # end
  end

  def destroy
    # Measure the time taken to process the logout action
    # StatsD.measure('auth.process_logout') do
      # StatsD.increment("logout")
      session[:user_id] = nil
      # StatsD.event('User Logged Out', "User with ID #{session[:user_id]} logged out") # Log an event for logout
      redirect_to login_path
    # end
  end

  private

  def auth_params
    params.require(:user).permit(:email, :password)
  end
end
