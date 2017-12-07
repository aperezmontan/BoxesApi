# frozen_string_literal: true

class BoxOwnerAdder
  include Service

  attr_reader :box, :user

  def initialize(box, user)
    @box = box
    @user = user
  end

  def run
    update_box
  end

  private

  def update_box
    box.update_attributes!(:owner => user)
    box
  end
end
