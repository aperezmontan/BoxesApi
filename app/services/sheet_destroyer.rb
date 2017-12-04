# frozen_string_literal: true

class SheetDestroyer
  include Service

  attr_reader :sheet, :user

  def initialize(sheet, user)
    @sheet = sheet
    @user = user
  end

  def run
    sheet.destroy!
  end
end
