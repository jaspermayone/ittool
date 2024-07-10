class BorrowersController < ApplicationController
  include Authenticatable

  before_action :ensure_authenticated

  def index
    # Measure the time taken to retrieve and display all borrowers
    # StatsD.measure('borrowers.index_request') do
      @borrowers = Borrower.all

      # Example gauge for tracking the number of borrowers
      # StatsD.gauge('borrowers.count', @borrowers.count)

      # StatsD.increment("borrowers_index_viewed")
    end
  end

  def show
    # Measure the time taken to find and display a specific borrower
    # StatsD.measure('borrowers.show_request') do
      @borrower = Borrower.find(params[:id])

      # Log an event when a specific borrower page is viewed
      # StatsD.event('Borrower Page Viewed', "User viewed borrower page with ID #{params[:id]}")

      # StatsD.increment("borrower_page_viewed")
    # end
  # end
end
