class AddClosedToSheets < ActiveRecord::Migration
  def change
    add_column :sheets, :closed, :boolean
  end
end
