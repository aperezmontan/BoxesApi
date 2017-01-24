class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :home_team
      t.text :away_team
      t.text :league
      t.datetime :game_date

      t.timestamps null: false
    end
  end
end
