class LoansController < ApplicationController
  include Authenticatable

  before_action :ensure_authenticated, only: [:create, :list, :pending, :out, :checkout, :checkin]

  def new
    # StatsD.increment("loan_new_viewed")

    # Measure the time taken to render the 'new' loan form
    # StatsD.measure('view.render_new_loan') do
      @loan = Loan.new
    # end
  end

  def create
    borrower_email = loan_params[:borrower_email]
    # StatsD.increment("loan_create_attempt")

    # Measure the time taken to find or create a borrower and save a loan
    # StatsD.measure('loan.create_process') do
      @borrower = Borrower.find_or_create_by(email: borrower_email)
      @loan = @borrower.loans.build(loan_params.except(:borrower_email))

      if @loan.save
        # StatsD.increment("loan_created")
        flash[:success] = "Submitted Successfully!"
        redirect_to loans_path
      else
        # StatsD.increment("loan_create_failed")
        flash.now[:danger] = "FAILED TO SUBMIT! Please check with a tech."
        render :new
      end
    # end
  end

  def list
    # StatsD.measure('loan.list_request') do
      @loans = Loan.all.order(created_at: :desc)
      # StatsD.increment("loans_list_viewed")
    # end
  end

  def pending
    # StatsD.measure('loan.pending_request') do
      @loans = Loan.where(status: "pending").order(created_at: :desc)
      # StatsD.increment("loans_pending_viewed")
    # end
  end

  def out
    # StatsD.measure('loan.out_request') do
      @loans = Loan.where(status: "out").order(created_at: :desc)
      # StatsD.increment("loans_out_viewed")
    # end
  end

  def checkout
    # StatsD.increment("loan_checkout_attempt")

    # Measure the time taken to process the checkout action
    # StatsD.measure('loan.checkout_process') do
      @loan = Loan.find(params[:id])
      loaner = Loaner.find_by(asset_tag: params[:asset_tag])

      if loaner.nil?
        # StatsD.increment("loan_checkout_failed")
        flash[:danger] = "Loaner not found."
        redirect_to overview_path and return
      end

      # check if loaner is marked as active
      if loaner.active === false
        # StatsD.increment("loan_checkout_failed")
        flash[:danger] = "Loaner is not active."
        redirect_to overview_path and return
      end

      unless loaner.available?
        # StatsD.increment("loan_checkout_failed")
        flash[:danger] = "Loaner is not available."
        redirect_to overview_path and return
      end

      begin
        loaner.loan!
        @loan.update!(loaner_id: loaner.id)
        @loan.loan!
        # StatsD.increment("loan_checked_out")
        flash[:success] = "Loan successful."
      rescue AASM::InvalidTransition => e
        # StatsD.increment("loan_checkout_failed")
        flash[:danger] = "Loan transition failed: #{e.message}"
      end

      redirect_to overview_path
    # end
  end

  def checkin
    # StatsD.increment("loan_checkin_attempt")

    # Measure the time taken to process the check-in action
    # StatsD.measure('loan.checkin_process') do
      @loan = Loan.find(params[:id])
      loaner = @loan.loaner

      if loaner.nil?
        # StatsD.increment("loan_checkin_failed")
        flash[:danger] = "Loaner not found."
        redirect_to overview_path
        return
      end

      if loaner.available?
        # StatsD.increment("loan_checkin_failed")
        flash[:danger] = "Loaner is already available."
        redirect_to overview_path
        return
      else
        loaner.return!
        @loan.return!
        # StatsD.increment("loan_checked_in")
        flash[:success] = "Check-in successful."
        redirect_to overview_path
      end
    # end
  end

  def extend
    @loan = Loan.find(params[:id])

    if @loan
      # Example logic: extend the due date by 1 day

      if @loan.status === 'disabled'
       @loan.enable!
      end

      @loan.due_date += 1.day
      if @loan.save
        flash[:notice] = 'Loan successfully extended.'
      else
        flash[:alert] = 'Failed to extend the loan.'
      end
    else
      flash[:alert] = 'Loan not found.'
    end

    redirect_to loans_list_out_path
  end

  def repair
    @laon = Loan.find(params[:id])

    if @loan
      @loan.repair!
      flash[:notice] = 'Loan successfully marked as repaired.'
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:reason, :borrower_email)
  end
end
