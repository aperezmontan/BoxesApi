class AddUniqueIndexGameIdSheetId < ActiveRecord::Migration[5.1]
  def change
    remove_column :sheets, :home_team
    remove_column :sheets, :away_team
    add_index :sheets, %i[id game_id], unique: true
  end
end
