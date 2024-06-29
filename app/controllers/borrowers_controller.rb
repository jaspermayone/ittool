class BorrowersController < ApplicationController
  include Authenticatable

  before_action :ensure_authenticated

def index
  @borrowers = Borrower.all
end

def show
  @borrower = Borrower.find(params[:id])
end

end
