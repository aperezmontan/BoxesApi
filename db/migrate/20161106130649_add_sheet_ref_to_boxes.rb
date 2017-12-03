class AddSheetRefToBoxes < ActiveRecord::Migration[5.1]
  def change
    add_reference :boxes, :sheet, index: true, foreign_key: true
  end
end
