class AddNumberToBoxes < ActiveRecord::Migration[5.1]
  def change
    add_column :boxes, :number, :integer, null: false
    add_index :boxes, %i[sheet_id number], unique: true
  end
end
