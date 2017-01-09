class AddBoxAmountToSheets < ActiveRecord::Migration
  def change
    add_column :sheets, :box_amount, :integer
  end
end
