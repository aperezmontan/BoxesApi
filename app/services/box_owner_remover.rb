# frozen_string_literal: true

class BoxOwnerRemover
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
    raise ServiceError::BoxOwnerRemover.new(box, "can't be updated by this User") if user.id != box.owner_id

    box.update_attributes!(:owner => nil)
    box
  end
end
