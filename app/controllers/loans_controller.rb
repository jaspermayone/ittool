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
      flash[:success] = "Loan application submitted successfully."
      redirect_to loans_path
    else
      flash.now[:danger] = "Loan application failed to submit."
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

  def router
  end

  def checkout
    @loaner = Loaner.find_by(asset_tag: checkout_loan_params[:asset_tag])

    if @loaner.present?
      @loan = Loan.find_by(loaner_id: @loaner.id, status: 'pending')

      if @loan.present?
        @loan.loan!
        flash[:success] = "Loan checked out successfully."
      else
        flash[:danger] = "Loan not found for this loaner."
      end
    else
      flash[:danger] = "Loaner not found."
    end

    redirect_to overview_path
  end

  # POST /loans/:id/assign_loaner
  def assign_loaner
    @loan = Loan.find(params[:loan_id])
    @loaner = Loaner.find_by(asset_tag: params[:asset_tag])

    if @loan && @loaner
      @loan.update(loaner_id: @loaner.id, status: 'pending')
      redirect_to overview_path, notice: "Loaner assigned successfully."
    else
      redirect_to overview_path, alert: "Loan or Loaner not found."
    end
  end

private

def checkout_loan_params
  params.permit(:asset_tag)
end

def loan_params
  params.require(:loan).permit(:reason, :borrower_email)
end
end
