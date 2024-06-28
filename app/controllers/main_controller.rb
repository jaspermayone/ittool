class MainController < ApplicationController

def index
end

def scanner
end

def overview
  @loans = Loan.all
  @loaners = Loaner.all
  @borrowers = Borrower.all
  @staff = User.all
  @loaners_out = Loaner.joins(:current_loan).where(loans: { status: 'borrowed' }).distinct
  @pending_loans = Loan.where(status: 'pending')
end

end
