class LoansController < ApplicationController
  def new
    @loan = Loan.new
  end

  def create
    borrower_email = loan_params[:borrower_email]

    # Find or create a Borrower based on the email
    @borrower = Borrower.find_or_create_by(email: borrower_email)

    # Build a new Loan associated with the found or created Borrower
    @loan = @borrower.loans.build(loan_params.except(:borrower_email))

    if @loan.save
      flash[:success] = "Submitted Successfully!"
      redirect_to loans_path
    else
      flash.now[:danger] = "FAILED TO SUBMIT! Please check with a tech."
      render :new
    end
  end

  def list
    @loans = Loan.all.order(created_at: :desc)
  end

  def pending
    @loans = Loan.where(status: "pending").order(created_at: :desc)
  end

  def out
    @loans = Loan.where(status: "out").order(created_at: :desc)
  end

  def checkout
    @loan = Loan.find(params[:id])

    loaner = Loaner.find_by(asset_tag: params[:asset_tag])

    if loaner.nil?
      flash[:danger] = "Loaner not found."
      redirect_to overview_path
      return
    end

    # if loaner.disabled? || loaner.maintenance? || loaner.loaned?
    if loaner.status != "available"
      flash[:danger] = "Loaner is not available, due to wrong state."
      redirect_to overview_path
      return
    else
      # update the loaner record
      loaner.loan!
      @loan.update!(loaner_id: loaner.id)
      @loan.loan!

      flash[:success] = "Loan successful."
      redirect_to overview_path
    end
  end

  def checkin
    @loan = Loan.find(params[:id])
    loaner = @loan.loaner

    if loaner.nil?
      flash[:danger] = "Loaner not found."
      redirect_to overview_path
      return
    end

    if loaner.available?
      flash[:danger] = "Loaner is already available."
      redirect_to overview_path
      return
    else
      loaner.return!
      @loan.return!

      flash[:success] = "Check-in successful."
      redirect_to overview_path
    end
  end


private

def loan_params
  params.require(:loan).permit(:reason, :borrower_email)
end

end
