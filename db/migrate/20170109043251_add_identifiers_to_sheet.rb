# frozen_string_literal: true

class AddIdentifiersToSheet < ActiveRecord::Migration[5.1]
  def change
    add_column :sheets, :sheet_code, :text
    add_column :sheets, :password, :text
    add_index :sheets, :sheet_code, unique: true
  end
end
