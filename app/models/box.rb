# frozen_string_literal: true

class Box < ApplicationRecord
  ### Associations
  belongs_to :sheet
  belongs_to :owner, :class_name => 'User', :optional => true
  has_one :user, :through => :sheet

  delegate :home_team, :to => :sheet
  delegate :away_team, :to => :sheet

  ### Callbacks :(
  # Need callbacks to ensure boxes are always linked to a sheet
  before_save do
    sheet_id_not_nil
    throw(:abort) if errors.present?
  end

  before_destroy do
    cannot_delete_without_sheet
    throw(:abort) if errors.present?
  end

  private

  def cannot_delete_without_sheet
    errors.add(:box, 'can only be destroyed when sheet is destroyed') unless destroyed_by_association
  end

  def sheet_id_not_nil
    errors.add(:box, 'must always be associated with a sheet') if sheet_id.nil?
  end
end
