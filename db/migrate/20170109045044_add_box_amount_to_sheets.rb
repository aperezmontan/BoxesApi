# frozen_string_literal: true

class AddBoxAmountToSheets < ActiveRecord::Migration[5.1]
  def change
    add_column :sheets, :box_amount, :integer
  end
end
