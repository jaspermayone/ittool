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
  @pending_loans = Loan.where(status: 'pending')
  @loaners_out = Loaner.includes(:current_loan).where(status: 'loaned')
end

end
