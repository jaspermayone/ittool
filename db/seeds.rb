# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# check what environment we are in and set variable to the current environment
current_env = Rails.env

# add dev resources
if current_env == "development"
  puts "Populating development environment data"

  borrowers = [
    { first_name: "J", last_name: "Mayone", email: "jmayone2025@huusd.org", graduation_year: 2025 },
    { first_name: "E", last_name: "Smith", email: "esmith2026@huusd.org", graduation_year: 2026 },
    { first_name: "L", last_name: "Jones", email: "ljones2027@huusd.org", graduation_year: 2027 },
    { first_name: "A", last_name: "Johnson", email: "ajohnson2028@huusd.org", graduation_year: 2028 },
    { first_name: "B", last_name: "Williams", email: "bwilliams2028@huusd.org", graduation_year: 2028 },
    { first_name: "C", last_name: "Brown", email: "cbrown2028@huusd.org", graduation_year: 2028 },
    { first_name: "D", last_name: "Davis", email: "ddavis2028@huusd.org", graduation_year: 2028 },
    { first_name: "E", last_name: "Miller", email: "emiller2028@huusd.org", graduation_year: 2028 },
    { first_name: "F", last_name: "Wilson", email: "fwilson2028@huusd.org", graduation_year: 2028 },
    { first_name: "G", last_name: "Moore", email: "gmoore2028@huusd.org", graduation_year: 2028 },
  ]
  borrowers.each { |borrower| Borrower.find_or_create_by!(borrower) }

  loaners = [
    { loaner_id: 1, asset_tag: "800001", serial_number: "LI9TFQIN19248AFF", status: "available" },
    { loaner_id: 2, asset_tag: "201333", serial_number: "LI9TFQIN19108128", status: "loaned" },
    { loaner_id: 3, asset_tag: "201535", serial_number: "LI9TFQIN19108328", status: "disabled" },
    { loaner_id: 4, asset_tag: "201524", serial_number: "LI9TFQIN19108343", status: "maintenance" },
    { loaner_id: 5, asset_tag: "800002", serial_number: "LI9TFQIN19248E6B", status: "available" },
    { loaner_id: 6, asset_tag: "201552", serial_number: "LI9TFQIN19108248", status: "available"},
    { loaner_id: 7, asset_tag: "201610", serial_number: "LI9TFQIN19108348", status: "available"},
    { loaner_id: 8, asset_tag: "400350", serial_number: "LI9TFQIN19248B14", status: "available"},
    { loaner_id: 9, asset_tag: "800003", serial_number: "LI9TFQIN19108363", status: "available"},
    { loaner_id: 10, asset_tag: "800004", serial_number: "LI9TFQIN191082DD", status: "available"},
    { loaner_id: 11, asset_tag: "800005", serial_number: "LI9TFQIN191082C7", status: "available"},
    { loaner_id: 12, asset_tag: "101770", serial_number: "LI9TFQIN19258159", status: "available"},
    { loaner_id: 13, asset_tag: "800006", serial_number: "LI9TFQIN19248AC7", status: "available"},
  ]
  loaners.each { |loaner| Loaner.find_or_create_by!(loaner) }

  loans = [
    { reason: 1, borrower_id: 1, loaned_at: DateTime.now - 1.day, returned_at: DateTime.now, status: "returned", loaner_id: 2 },
    { reason: 2, borrower_id: 2, loaned_at: DateTime.now - 2.days, returned_at: DateTime.now, status: "returned", loaner_id: 3 },
    { reason: 3, borrower_id: 3, loaned_at: DateTime.now - 3.days, returned_at: DateTime.now, status: "returned", loaner_id: 4 },
    { reason: 2, borrower_id: 4, loaned_at: DateTime.now - 4.days, returned_at: DateTime.now, status: "returned", loaner_id: 5 },
    { reason: 1, borrower_id: 1, loaned_at: DateTime.now - 5.days, returned_at: DateTime.now, status: "returned", loaner_id: 6 },
    { reason: 1, borrower_id: 1, loaned_at: DateTime.now - 1.day, status: "pending", loaner_id: 7 },
    { reason: 2, borrower_id: 2, loaned_at: DateTime.now - 2.days, status: "pending", loaner_id: 8 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 9 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
    { reason: 3, borrower_id: 1, loaned_at: DateTime.now - 3.days, status: "returned", loaner_id: 7 },
  ]
  loans.each { |loan| Loan.find_or_create_by!(loan) }

  # Manually setting the current_loan_id for Loaner with loaner_id 7
  loaner_7 = Loaner.find(7)
  pending_loan_for_loaner_7 = Loan.find_by(loaner_id: 7, status: "pending")
  if pending_loan_for_loaner_7
    loaner_7.update!(current_loan_id: pending_loan_for_loaner_7.id)
    loaner_7.loan! # trigger the loan event
  end

  # create a user (has secure password)
  User.find_or_create_by!(email: "me@jaspermayone.com") do |user|
    user.f_name = "Jasper"
    user.l_name = "Mayone"
    user.password = "password"
    user.password_confirmation = "password"
    user.role = "admin"
  end


end
