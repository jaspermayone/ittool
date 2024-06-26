class AddAasmStateToExisting < ActiveRecord::Migration[7.1]
  def change
    add_column :loans, :status, :string
    add_index :loans, :status

    add_column :assets, :status, :string
    add_index :assets, :status
  end
end
