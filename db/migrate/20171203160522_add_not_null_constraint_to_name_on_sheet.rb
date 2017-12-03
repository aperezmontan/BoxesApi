class AddNotNullConstraintToNameOnSheet < ActiveRecord::Migration[5.1]
  def change
    change_column_null :sheets, :name, false
  end
end
