class AddGameToSheets < ActiveRecord::Migration[5.1]
  def change
    add_reference :sheets, :game, index: true, foreign_key: true
  end
end
