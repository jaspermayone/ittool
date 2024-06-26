class CreateBorrowers < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :graduation_year

      t.timestamps
    end
  end
end
