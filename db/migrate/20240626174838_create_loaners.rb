class CreateLoaners < ActiveRecord::Migration[7.1]
  def change
    create_table :loaners do |t|
      t.string :asset_tag
      t.integer :loaner_id
      t.string :serial_number
      t.string :status
      t.timestamps

      t.index :status
      t.index :asset_tag
      t.index :loaner_id
    end
  end
end
