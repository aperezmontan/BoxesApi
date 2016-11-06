class AddSheetRefToBoxes < ActiveRecord::Migration
  def change
    add_reference :boxes, :sheet, index: true, foreign_key: true
  end
end
