class AddClosedToSheets < ActiveRecord::Migration[5.1]
  def change
    add_column :sheets, :closed, :boolean
  end
end
