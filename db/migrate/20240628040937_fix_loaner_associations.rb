class FixLoanerAssociations < ActiveRecord::Migration[7.1]
  def change
    # Remove incorrect association (if necessary)
    # remove_column :loaners, :current_loan_id  # Uncomment if 'current_loan_id' column needs to be removed

    # Add correct associations
    unless column_exists?(:loans, :loaner_id)
      add_reference :loans, :loaner, foreign_key: true
    end

    unless column_exists?(:loaners, :current_loan_id)
      add_reference :loaners, :current_loan, foreign_key: { to_table: :loans }
    end

    unless ActiveRecord::Base.connection.table_exists?(:loaners_borrowers)
      create_table :loaners_borrowers, id: false do |t|
        t.belongs_to :loaner
        t.belongs_to :borrower
      end
      add_index :loaners_borrowers, [:loaner_id, :borrower_id], unique: true
    end
  end
end
