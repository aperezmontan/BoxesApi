class CreateSheets < ActiveRecord::Migration[5.1]
  def change
    create_table :sheets do |t|
      t.string :home_team
      t.string :away_team
      t.string :name

      t.timestamps null: false
    end
  end
end
