class LoansController < ApplicationController
  def new
    @loan = Loan.new
  end

  def create
    # Extract the borrower's email from loan_params
    borrower_email = loan_params[:borrower_email]

    # Find or create a Borrower based on the email
    @borrower = Borrower.find_or_create_by!(email: borrower_email)

    # Build a new Loan associated with the found or created Borrower
    @loan = @borrower.loans.build(loan_params.except(:borrower_email))

    if @loan.save!
      flash[:success] = "Loan application submitted successfully."
      redirect_to loans_path
    else
      render :new, flash[:danger] = "Loan application failed to submit."
    end
  end

  def list
    @loans = Loan.all
  end

  def pending
    @loans = Loan.where(status: "pending")
  end

  def out
    @loans = Loan.where(status: "out")
  end

  # def out
  #   @loans = Loan.where.not(loaned_at: nil).where(returned_at: nil)
  # end

  # def pending
  #   # @loans = Loan.where(loaned_at: nil)
  # end

  def router
  end

  private

  def loan_params
    params.require(:loan).permit(:reason, :borrower_email)
  end
end
