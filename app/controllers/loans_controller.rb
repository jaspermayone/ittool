class LoansController < ApplicationController
  include Authenticatable

  before_action :ensure_authenticated, only: [:create, :list, :pending, :out, :checkout, :checkin]

  def new
    @loan = Loan.new
    StatsD.increment("loan_new_viewed")
  end

  def create
    borrower_email = loan_params[:borrower_email]
    StatsD.increment("loan_create_attempt")

    # Find or create a Borrower based on the email
    @borrower = Borrower.find_or_create_by(email: borrower_email)

    # Build a new Loan associated with the found or created Borrower
    @loan = @borrower.loans.build(loan_params.except(:borrower_email))

    if @loan.save
      StatsD.increment("loan_created")
      flash[:success] = "Submitted Successfully!"
      redirect_to loans_path
    else
      StatsD.increment("loan_create_failed")
      flash.now[:danger] = "FAILED TO SUBMIT! Please check with a tech."
      render :new
    end
  end

  def list
    @loans = Loan.all.order(created_at: :desc)
    StatsD.increment("loans_list_viewed")
  end

  def pending
    @loans = Loan.where(status: "pending").order(created_at: :desc)
    StatsD.increment("loans_pending_viewed")
  end

  def out
    @loans = Loan.where(status: "out").order(created_at: :desc)
    StatsD.increment("loans_out_viewed")
  end

  def checkout
    @loan = Loan.find(params[:id])
    loaner = Loaner.find_by(asset_tag: params[:asset_tag])

    StatsD.increment("loan_checkout_attempt")

    if loaner.nil?
      StatsD.increment("loan_checkout_failed")
      flash[:danger] = "Loaner not found."
      redirect_to overview_path and return
    end

    unless loaner.available?
      StatsD.increment("loan_checkout_failed")
      flash[:danger] = "Loaner is not available."
      redirect_to overview_path and return
    end

    begin
      loaner.loan!
      @loan.update!(loaner_id: loaner.id)
      @loan.loan!
      StatsD.increment("loan_checked_out")
      flash[:success] = "Loan successful."
    rescue AASM::InvalidTransition => e
      StatsD.increment("loan_checkout_failed")
      flash[:danger] = "Loan transition failed: #{e.message}"
    end

    redirect_to overview_path
  end

  def checkin
    @loan = Loan.find(params[:id])
    loaner = @loan.loaner

    StatsD.increment("loan_checkin_attempt")

    if loaner.nil?
      flash[:danger] = "Loaner not found."
      StatsD.increment("loan_checkin_failed")
      redirect_to overview_path
      return
    end

    if loaner.available?
      flash[:danger] = "Loaner is already available."
      StatsD.increment("loan_checkin_failed")
      redirect_to overview_path
      return
    else
      loaner.return!
      @loan.return!

      StatsD.increment("loan_checked_in")
      flash[:success] = "Check-in successful."
      redirect_to overview_path
    end
  end


private

def loan_params
  params.require(:loan).permit(:reason, :borrower_email)
end

end
