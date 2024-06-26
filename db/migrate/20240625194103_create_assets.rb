class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.integer :asset_id
      t.string :type
      t.integer :loaner_id

      t.timestamps
    end
  end
end
