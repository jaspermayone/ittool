class MainController < ApplicationController
  include Authenticatable
  require "csv"

  before_action :ensure_authenticated, only: [:overview, :scanner, :import]
  before_action :ensure_super_admin, only: [:import]

  def scanner
    # StatsD.increment("scanner_viewed")
  end

  def overview
    # StatsD.measure('overview.load_time') do
      @loans = Loan.all
      @loaners = Loaner.all
      @borrowers = Borrower.all
      @staff = User.all
      @pending_loans = Loan.where(status: 'pending')
      @loaners_out = Loaner.includes(:current_loan).where(status: 'loaned')

      # StatsD.increment("overview_viewed")
    # end
  end

  def temp
    @borrower = Borrower.find(1)
    # StatsD.increment("temp_action_triggered")
    # StatsD.measure('temp.mail_sending') do
      BorrowerMailer.notify_repair_ready(@borrower).deliver_now
      BorrowerMailer.notify_loaner_disabled(@borrower).deliver_now
      BorrowerMailer.return_reminder(@borrower).deliver_now
    # end
    # Consider adding an event to log this action in a more descriptive way if needed.
  end

  def import
    # StatsD.increment("import_viewed")
  end

  def process_import
    # StatsD.increment("import_attempt")
    if params[:csv_file].present?
      csv_file = params[:csv_file].path
      # StatsD.measure('csv_processing_time') do
        process_csv(csv_file)
      # end
      # StatsD.increment("import_successful")
      flash[:notice] = 'CSV file imported successfully.'
      redirect_to overview_path
    else
      # StatsD.increment("import_failed")
      flash[:alert] = 'Please select a CSV file to import.'
      redirect_to import_path
    end
  end

  private

  def process_csv(file_path)
    # StatsD.increment("csv_processing_attempt")
    row_count = 0
    # StatsD.measure('csv_processing_time') do
      CSV.foreach(file_path, headers: true) do |row|
        row_count += 1

        # Create a new loaner (this needs to be adjusted based on your actual model attributes)
        Loaner.create!(asset_tag: row['asset_tag'], serial_number: row['serial_number'], loaner_id: 100)
        # StatsD.increment("csv_row_processed")
      end
    # end
    # Optionally set a gauge to reflect the number of rows processed
    # StatsD.gauge('csv_row_count', row_count)
  end
end
