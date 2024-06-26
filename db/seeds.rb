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
# Loaner.create!(loaner_id: 11, asset_tag: "800005", serial_number: "LI9TFQIN191082C7")
# Loaner.create!(loaner_id: 12, asset_tag: "101770", serial_number: "LI9TFQIN19258159")
# Loaner.create!(loaner_id: 13, asset_tag: "800006", serial_number: "LI9TFQIN19248AC7")

end
