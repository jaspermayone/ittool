class FixLoanReason < ActiveRecord::Migration[7.1]
  def change
    # loan_reason is an interger with a limit of 1, it should be an integer with a limit of 3
    change_column :loans, :reason, :integer, limit: 3
  end
end
