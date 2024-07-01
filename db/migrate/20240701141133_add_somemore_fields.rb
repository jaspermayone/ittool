class AddSomemoreFields < ActiveRecord::Migration[7.1]
  def change
    add_column :loans, :borrowed_device_repaired, :boolean
    add_column :loaners, :freindly_id, :integer
    add_column :loaners, :active, :boolean
    add_column :borrowers, :flagged, :boolean
  end
end
