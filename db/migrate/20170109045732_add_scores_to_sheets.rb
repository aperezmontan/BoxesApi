class AddScoresToSheets < ActiveRecord::Migration[5.1]
  def change
    add_column :sheets, :home_team_score_row, :integer, :array => true
    add_column :sheets, :away_team_score_row, :integer, :array => true
  end
end
