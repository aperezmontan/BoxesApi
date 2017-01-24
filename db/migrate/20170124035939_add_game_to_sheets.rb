class AddGameToSheets < ActiveRecord::Migration
  def change
    add_reference :sheets, :game, index: true, foreign_key: true
  end
end
