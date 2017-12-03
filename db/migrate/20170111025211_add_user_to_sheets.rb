class AddUserToSheets < ActiveRecord::Migration[5.1]
  def change
    add_reference :sheets, :user, index: true, foreign_key: true
  end
end
