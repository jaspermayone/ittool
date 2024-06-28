class BorrowersController < ApplicationController

def index
  @borrowers = Borrower.all
end

def show
  @borrower = Borrower.find(params[:id])
end

end
