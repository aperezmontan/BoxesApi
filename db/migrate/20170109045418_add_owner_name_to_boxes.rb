class AddOwnerNameToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :owner_name, :text
  end
end
