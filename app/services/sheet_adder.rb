class SheetAdder
  include Service

  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def run
    add_sheet
  end

  private

  def add_sheet
    @sheet ||= ::Sheet.start_new_sheet(params.merge(:user_id => user.id))
  end
end