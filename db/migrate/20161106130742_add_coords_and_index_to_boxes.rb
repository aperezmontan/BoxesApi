class AddCoordsAndIndexToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :home_team_id, :string
    add_column :boxes, :away_team_id, :string

    add_index :boxes, [:home_team_id, :away_team_id, :sheet_id], :unique => true
  end
end
