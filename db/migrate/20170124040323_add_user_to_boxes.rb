class AddUserToBoxes < ActiveRecord::Migration
  def change
    add_reference :boxes, :user, index: true, foreign_key: true
  end
end
