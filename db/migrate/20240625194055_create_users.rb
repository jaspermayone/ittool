class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :f_name
      t.string :l_name
      t.string :email
      t.string :password_digest
      t.integer :role, default: 0, null: false, limit: 3

      t.timestamps
    end
  end
end
