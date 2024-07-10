class LoanersController < ApplicationController
  include Authenticatable

  before_action :set_loaner, only: [:show, :return, :enable, :disable, :repair, :broken]
  before_action :ensure_authenticated, only: [:show, :list, :return, :enable, :disable, :repair, :broken, :new, :create]
  before_action :ensure_super_admin, only: [:new, :create]

  def new
    # StatsD.increment("loaner_new_viewed")

    # Measure the time taken to render the 'new' loaner form
    # StatsD.measure('view.render_new_loaner') do
      @loaner = Loaner.new
    # end
  end

  def create
    # StatsD.increment("loaner_create_attempt")

    # Measure the time taken to create a new loaner
    # StatsD.measure('loaner.create') do
      @loaner = Loaner.new(loaner_params)
      if @loaner.save
        # StatsD.increment("loaner_created")
        redirect_to @loaner, notice: 'Loaner was successfully created.'
      else
        # StatsD.increment("loaner_create_failed")
        render :new
      end
    # end
  end

  def list
    # Measure the time taken to retrieve and display all loaners
    # StatsD.measure('loaners.list_request') do
      @loaners = Loaner.all
      # StatsD.increment("loaners_list_viewed")
    # end
  end

  def show
    # StatsD.increment("loaner_page_viewed")
    # Measure the time taken to find and display the loaner
    # StatsD.measure('loaner.show_request') do
      @loaner
    # end
  end

  def return
    # StatsD.increment("loaner_return_attempt")
    # StatsD.measure('loaner.return_action') do
      if @loaner.present?
        @loaner.mark_as_returned
        # StatsD.increment("loaner_returned")
        redirect_to loaners_path, notice: "Asset checked in successfully."
      else
        # StatsD.increment("loaner_return_failed")
        redirect_to loaners_path, alert: "Loaner not found."
      end
    # end
  end

  def enable
    # StatsD.increment("loaner_enable_attempt")
    # StatsD.measure('loaner.enable_action') do
      if @loaner.present?
        @loaner.mark_as_enabled
        # StatsD.increment("loaner_enabled")
        redirect_to loaners_path, notice: "Asset marked as enabled successfully."
      else
        # StatsD.increment("loaner_enable_failed")
        redirect_to loaners_path, alert: "Loaner not found."
      end
    # end
  end

  def disable
    # StatsD.increment("loaner_disable_attempt")
    # StatsD.measure('loaner.disable_action') do
      if @loaner.present?
        @loaner.mark_as_disabled
        # StatsD.increment("loaner_disabled")
        redirect_to loaners_path, notice: "Asset marked as disabled successfully."
      else
        # StatsD.increment("loaner_disable_failed")
        redirect_to loaners_path, alert: "Loaner not found."
      end
    # end
  end

  def broken
    # StatsD.increment("loaner_broken_attempt")
    # StatsD.measure('loaner.broken_action') do
      if @loaner.present?
        @loaner.mark_as_broken
        # StatsD.increment("loaner_broken")
        redirect_to loaners_path, notice: "Asset marked as broken successfully."
      else
        # StatsD.increment("loaner_broken_failed")
        redirect_to loaners_path, alert: "Loaner not found."
      end
    # end
  end

  def repair
    # StatsD.increment("loaner_repair_attempt")
    # StatsD.measure('loaner.repair_action') do
      if @loaner.present?
        @loaner.mark_as_repaired
        # StatsD.increment("loaner_repaired")
        redirect_to loaners_path, notice: "Asset marked as repaired successfully."
      else
        # StatsD.increment("loaner_repair_failed")
        redirect_to loaners_path, alert: "Loaner not found."
      end
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_loaner
    # StatsD.measure('loaner.find') do
      @loaner = Loaner.find(params[:id])
    # end
  end

  def loaner_params
    params.require(:loaner).permit(:asset_tag, :serial_number, :status)
  end

end
