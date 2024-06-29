class LoanersController < ApplicationController
  include Authenticatable

  before_action :set_loaner, only: [:show, :return, :enable, :disable, :repair, :broken]
  before_action :ensure_authenticated, only: [:show, :list, :return, :enable, :disable, :repair, :broken, :new, :create]
before_action :ensure_super_admin, only: [:new, :create]

def new
  @loaner = Loaner.new
end

def create
  @loaner = Loaner.new(loaner_params)
  if @loaner.save
    redirect_to @loaner, notice: 'Loaner was successfully created.'
  else
    render :new
  end
end


def list
  @loaners = Loaner.all
end

def show
  @loaner
end

  # GET /loaners/:id/return
  def return
    if @loaner.present?
      @loaner.mark_as_returned
      redirect_to loaners_path, notice: "Asset checked in successfully."
    else
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  # GET /loaners/:id/enable
  def enable
    if @loaner.present?
      @loaner.mark_as_enabled
      redirect_to loaners_path, notice: "Asset marked as enabled successfully."
    else
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  # GET /loaners/:id/disable
  def disable
    if @loaner.present?
      @loaner.mark_as_disabled
      redirect_to loaners_path, notice: "Asset marked as disabled successfully."
    else
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  def broken
    if @loaner.present?
      @loaner.mark_as_broken
      redirect_to loaners_path, notice: "Asset marked as broken successfully."
    else
      redirect_to loaners_path, alert: "Loaner not found."
    end
  end

  # GET /loaners/:id/repair
  def repair
    if @loaner.present?
      @loaner.mark_as_repaired
      redirect_to loaners_path, notice: "Asset marked as repaired successfully."
    else
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
