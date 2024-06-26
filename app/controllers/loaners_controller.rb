class LoanersController < ApplicationController
  # before_action :set_loaner, only: [:show, :edit, :update, :destroy, :loan, :return, :enable]
  before_action :set_loaner, only: [:show, :loan, :return, :enable]


def list
  # @loaners = Loaner.all!sort_by(&:asset_tag)
  @loaners = Loaner.all
end

def show
  # Assuming you want to show details of @loaner
  @loaner
end

 # PATCH /loaners/1/loan
 def loan
  @loaner.mark_as_loaned
  redirect_to loaners_path, notice: "Asset checked out successfully."
end

# PATCH /loaners/1/return
def return
  @loaner.mark_as_returned
  redirect_to loaners_path, notice: "Asset checked in successfully."
end

# PATCH /loaners/1/enable
def enable
  @loaner.mark_as_enabled
  redirect_to loaners_path, notice: "Asset marked as available successfully."
end

private
# Use callbacks to share common setup or constraints between actions.
def set_loaner
  @loaner = Loaner.find(params[:id])
end

end
