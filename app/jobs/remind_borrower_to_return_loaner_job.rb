class RemindBorrowerToReturnLoanerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    loan_id = args[0]
    loan = Loan.find(loan_id)

    # check if loaner is due
    if loan.due_date < Date.today && loan.status == "out"
      # send reminder email to borrower
      LoanMailer.with(loan: loan).reminder_email.deliver_now
    end

  end
end
