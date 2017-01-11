class AddUserToSheets < ActiveRecord::Migration
  def change
    add_reference :sheets, :user, index: true, foreign_key: true
  end
end
