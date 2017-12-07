class ChangeTeamsOnGamesToIntegers < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :home_team, 'integer USING CAST(home_team AS integer)'
    change_column :games, :away_team, 'integer USING CAST(away_team AS integer)'
  end
end
