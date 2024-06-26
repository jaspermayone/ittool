class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.integer :reason, null: false, limit: 1
      t.references :borrower, null: false, foreign_key: true
      t.datetime :loaned_at
      t.datetime :returned_at
      t.string :status

      t.timestamps

      t.index :status
    end
  end
end
