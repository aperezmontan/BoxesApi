class AddOwnerNameToBoxes < ActiveRecord::Migration[5.1]
  def change
    add_column :boxes, :owner_name, :text
  end
end
