# frozen_string_literal: true

class AddCoordsAndIndexToBoxes < ActiveRecord::Migration[5.1]
  def change
    add_column :boxes, :home_team_id, :string
    add_column :boxes, :away_team_id, :string

    add_index :boxes, %i[home_team_id away_team_id sheet_id], unique: true
  end
end
