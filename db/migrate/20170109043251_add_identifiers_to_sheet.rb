class AddIdentifiersToSheet < ActiveRecord::Migration
  def change
    add_column :sheets, :sheet_code, :text
    add_column :sheets, :password, :text
    add_index :sheets, :sheet_code, :unique => true
  end
end
