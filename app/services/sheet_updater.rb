# frozen_string_literal: true

class SheetUpdater
  include Service

  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def run
    update_sheet
  end

  private

  def sheet
    @sheet ||= ::Sheet.find(params.fetch('id'))
  end

  def update_sheet
    sheet.update_attributes!(params)
    sheet
  end
end
