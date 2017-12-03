class CreateUniqueIndexForSheetsOnUserGameName < ActiveRecord::Migration[5.1]
  def change
    add_index :sheets, [:user_id, :game_id, :name], :unique => true
    remove_index :sheets, :name => 'index_sheets_on_user_id'
  end
end
