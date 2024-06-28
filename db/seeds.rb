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
curent_env = Rails.env

# add dev resources
if curent_env == "development"
  puts "Populating development environment data"

Borrower.create!(first_name: "J", last_name: "Mayone", email: "jmayone2025@huusd.org", graduation_year: 2025)
Borrower.create!(first_name: "E", last_name: "Smith", email: "esmith2026@huusd.org", graduation_year: 2026)
Borrower.create!(first_name: "L", last_name: "Jones", email: "ljones2027@huusd.org", graduation_year: 2027)
Borrower.create!(first_name: "A", last_name: "Johnson", email: "ajohnson2028@huusd.org", graduation_year: 2028)

Loaner.create!(loaner_id: 1, asset_tag: "800001", serial_number: "LI9TFQIN19248AFF", status: "available")
Loaner.create!(loaner_id: 2, asset_tag: "201333", serial_number: "LI9TFQIN19108128", status: "loaned")
Loaner.create!(loaner_id: 3, asset_tag: "201535", serial_number: "LI9TFQIN19108328", status: "disabled")
Loaner.create!(loaner_id: 4, asset_tag: "201524", serial_number: "LI9TFQIN19108343", status: "maintenance")

Loaner.create!(loaner_id: 5, asset_tag: "800002", serial_number: "LI9TFQIN19248E6B")
Loaner.create!(loaner_id: 6, asset_tag: "201552", serial_number: "LI9TFQIN19108248")
Loaner.create!(loaner_id: 7, asset_tag: "201610", serial_number: "LI9TFQIN19108348")
Loaner.create!(loaner_id: 8, asset_tag: "400350", serial_number: "LI9TFQIN19248B14")
Loaner.create!(loaner_id: 9, asset_tag: "800003", serial_number: "LI9TFQIN19108363")
Loaner.create!(loaner_id: 10, asset_tag: "800004", serial_number: "LI9TFQIN191082DD")
Loaner.create!(loaner_id: 11, asset_tag: "800005", serial_number: "LI9TFQIN191082C7")
Loaner.create!(loaner_id: 12, asset_tag: "101770", serial_number: "LI9TFQIN19258159")
Loaner.create!(loaner_id: 13, asset_tag: "800006", serial_number: "LI9TFQIN19248AC7")

# add some loan history
#
# create_table "loans", force: :cascade do |t|
#   t.integer "reason", limit: 3, null: false
#   t.integer "borrower_id", null: false
#   t.datetime "loaned_at"
#   t.datetime "returned_at"
#   t.string "status"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.integer "loaner_id"
#   t.index ["borrower_id"], name: "index_loans_on_borrower_id"
#   t.index ["loaner_id"], name: "index_loans_on_loaner_id"
#   t.index ["status"], name: "index_loans_on_status"
# end

Loan.create!(reason: 1, borrower_id: 1, loaned_at: DateTime.now - 1.day, returned_at: DateTime.now, status: "returned", loaner_id: 2)
sleep(5)
Loan.create!(reason: 2, borrower_id: 2, loaned_at: DateTime.now - 2.days, returned_at: DateTime.now, status: "returned", loaner_id: 3)
sleep(5)
Loan.create!(reason: 3, borrower_id: 3, loaned_at: DateTime.now - 3.days, returned_at: DateTime.now, status: "returned", loaner_id: 4)
sleep(5)
Loan.create!(reason: 2, borrower_id: 4, loaned_at: DateTime.now - 4.days, returned_at: DateTime.now, status: "returned", loaner_id: 5)
sleep(5)
Loan.create!(reason: 1, borrower_id: 1, loaned_at: DateTime.now - 5.days, returned_at: DateTime.now, status: "returned", loaner_id: 6)


end
