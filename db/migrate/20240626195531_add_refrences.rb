class AddRefrences < ActiveRecord::Migration[7.1]
  def change
    add_reference :loans, :loaner, foreign_key: true
  end
end
