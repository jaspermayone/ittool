class BorrowersController < ApplicationController
  include Authenticatable

  before_action :ensure_authenticated

def index
  @borrowers = Borrower.all
  StatsD.increment("borrowers_index_viewed")
end

def show
  @borrower = Borrower.find(params[:id])
  StatsD.increment("borrower_page_viewed")
end

end
