class LoanersController < ApplicationController
  include Authenticatable

  before_action :set_loaner, only: [:show, :return, :enable, :disable, :repair, :broken]
  before_action :ensure_authenticated, only: [:show, :list, :return, :enable, :disable, :repair, :broken, :new, :create]
before_action :ensure_super_admin, only: [:new, :create]

def new
  @loaner = Loaner.new
  StatsD.increment("loaner_new_viewed")
end

def create
  @loaner = Loaner.new(loaner_params)
  StatsD.increment("loaner_create_attempt")

  if @loaner.save
    redirect_to @loaner, notice: 'Loaner was successfully created.'
    StatsD.increment("loaner_created")
  else
    StatsD.increment("loaner_create_failed")
    render :new
  end
end


def list
  @loaners = Loaner.all
  StatsD.increment("loaners_list_viewed")
end

def show
  @loaner
  StatsD.increment("loaner_page_viewed")
end

  # GET /loaners/:id/return
  def return
    StatsD.increment("loaner_return_attempt")
    if @loaner.present?
      @loaner.mark_as_returned
      StatsD.increment("loaner_returned")
      redirect_to loaners_path, notice: "Asset checked in successfully."
    else
      StatsD.increment("loaner_return_failed")
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  # GET /loaners/:id/enable
  def enable
    StatsD.increment("loaner_enable_attempt")
    if @loaner.present?
      @loaner.mark_as_enabled
      StatsD.increment("loaner_enabled")
      redirect_to loaners_path, notice: "Asset marked as enabled successfully."
    else
      StatsD.increment("loaner_enable_failed")
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  # GET /loaners/:id/disable
  def disable
    StatsD.increment("loaner_disable_attempt")
    if @loaner.present?
      @loaner.mark_as_disabled
      StatsD.increment("loaner_disabled")
      redirect_to loaners_path, notice: "Asset marked as disabled successfully."
    else
      StatsD.increment("loaner_disable_failed")
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  def broken
    StatsD.increment("loaner_broken_attempt")
    if @loaner.present?
      @loaner.mark_as_broken
      StatsD.increment("loaner_broken")
      redirect_to loaners_path, notice: "Asset marked as broken successfully."
    else
      StatsD.increment("loaner_broken_failed")
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  # GET /loaners/:id/repair
  def repair
    StatsD.increment("loaner_repair_attempt")
    if @loaner.present?
      @loaner.mark_as_repaired
      StatsD.increment("loaner_repaired")
      redirect_to loaners_path, notice: "Asset marked as repaired successfully."
    else
      StatsD.increment("loaner_repair_failed")
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end



private
# Use callbacks to share common setup or constraints between actions.
def set_loaner
  @loaner = Loaner.find(params[:id])
end

def loaner_params
  params.require(:loaner).permit(:asset_tag, :serial_number, :status)
end

end
