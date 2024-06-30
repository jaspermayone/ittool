class MainController < ApplicationController
  include Authenticatable
  require "csv"

  before_action :ensure_authenticated, only: [:overview, :scanner, :import]
  before_action :ensure_super_admin, only: [:import]

  def scanner
    StatsD.increment("scanner_viewed")
  end

  def overview
    @loans = Loan.all
    @loaners = Loaner.all
    @borrowers = Borrower.all
    @staff = User.all
    @pending_loans = Loan.where(status: 'pending')
    @loaners_out = Loaner.includes(:current_loan).where(status: 'loaned')

    StatsD.increment("overview_viewed")
  end

  def temp
    @borrower = Borrower.find(1)
    BorrowerMailer.notify_repair_ready(@borrower).deliver_now
    BorrowerMailer.notify_loaner_disabled(@borrower).deliver_now
    BorrowerMailer.return_reminder(@borrower).deliver_now

    # StatsD.increment("temp")
  end

  def import
    # This action will render the import form
    StatsD.increment("import_viewed")
  end

  def process_import
    StatsD.increment("import_attempt")
    if params[:csv_file].present?
      csv_file = params[:csv_file].path
      process_csv(csv_file)
      StatsD.increment("import_successful")
      flash[:notice] = 'CSV file imported successfully.'
      redirect_to overview_path
    else
      StatsD.increment("import_failed")
      flash[:alert] = 'Please select a CSV file to import.'
      redirect_to import_path
    end
  end

  private

  def process_csv(file_path)
    StatsD.increment("csv_processing_attempt")
    CSV.foreach(file_path, headers: true) do |row|
      puts "\n\n"
      puts "Processing row: #{row}"
      puts row.to_hash
      puts "\n\n"

      # Loaner.find_or_create_by!(asset_tag: row['asset_tag'], ) do |loaner|
      #   loaner.serial_number = row['serial_number']
      #   loaner.status = row['status']
      # end

      Loaner.new(asset_tag: row['asset_tag'], serial_number: row['serial_number'], loaner_id: 100).save!
      StatsD.increment("csv_row_processed")
    end
  end

end
