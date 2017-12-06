class ChangeOwnerNameToOwnerIdOnBoxes < ActiveRecord::Migration[5.1]
  def change
    remove_column :boxes, :owner_name
    add_reference :boxes, :owner, index: { unique: true }, foreign_key: {to_table: :users}
  end
end
